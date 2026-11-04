#!/usr/bin/env bash
# Bereitet einen Debian-Laptop für den VM-Auftrag vor.
#
# Die Betreuungsperson führt es vor dem Austeilen auf jedem Laptop aus, angemeldet mit dem
# Benutzer, mit dem die Schnupperlehrlinge arbeiten:
#   bash <(curl -fsSL https://raw.githubusercontent.com/zeliharuya/vm-task/main/setup.sh || wget -qO- https://raw.githubusercontent.com/zeliharuya/vm-task/main/setup.sh)
#
# Lokal:
#   bash setup.sh                -> Programme installieren, Ergebnis-Ordner anlegen, Ergebnisse bleiben
#   bash setup.sh --neue-gruppe  -> zusätzlich: Ergebnisse, VMs «vm-*», heruntergeladene Debian-ISOs
#                                   und SSH-Schlüssel der VMs löschen (fragt vorher nach)
set -euo pipefail

# Pfad merken, bevor das Skript den Ordner wechselt (für das Selbstlöschen am Schluss).
SKRIPT="${BASH_SOURCE[0]:-}"
[[ -f "$SKRIPT" ]] && SKRIPT="$(realpath "$SKRIPT")"

ERGEBNISSE="$HOME/VM-Ergebnisse"
# xdg-user-dir gibt $HOME zurück, wenn kein Download-Ordner eingetragen ist.
DOWNLOADS="$(xdg-user-dir DOWNLOAD 2>/dev/null || true)"
[[ -z "$DOWNLOADS" || "$DOWNLOADS" == "$HOME" ]] && DOWNLOADS="$HOME/Downloads"
VERBINDUNG="qemu:///system"
PAKETE=(virt-manager libvirt-daemon-system libvirt-clients qemu-system-x86 qemu-utils
        dnsmasq-base nano curl wget openssh-client)
NEUE_GRUPPE=0
[[ "${1:-}" == "--neue-gruppe" ]] && NEUE_GRUPPE=1

WARNUNGEN=()
warnung() { WARNUNGEN+=("$1"); }

als_root() {
    if [[ $EUID -eq 0 ]]; then "$@"; else sudo "$@"; fi
}

if ! command -v apt-get >/dev/null; then
    echo "Dieses Skript ist für Debian gemacht (apt-get fehlt)."
    exit 1
fi
if [[ $EUID -ne 0 ]] && ! command -v sudo >/dev/null; then
    echo "sudo fehlt. Bitte als root «apt-get install sudo» ausführen und den Benutzer in die Gruppe sudo aufnehmen."
    exit 1
fi
BENUTZER="$(id -un)"
if [[ $EUID -eq 0 ]]; then
    echo "Bitte nicht als root ausführen, sondern als der Benutzer, mit dem die Schnupperlehrlinge arbeiten."
    exit 1
fi

# --- Programme -----------------------------------------------------------------
fehlend=()
for p in "${PAKETE[@]}"; do
    dpkg-query -W -f='${Status}' "$p" 2>/dev/null | grep -q "ok installed" || fehlend+=("$p")
done
if [[ ${#fehlend[@]} -gt 0 ]]; then
    echo "Es fehlt noch: ${fehlend[*]}. Das wird jetzt installiert (sudo-Passwort nötig)."
    als_root apt-get update -qq
    als_root apt-get install -y -qq "${fehlend[@]}"
fi

# --- Benutzer darf VMs verwalten (Gruppe libvirt) ------------------------------
NEU_ANMELDEN=0
if ! id -nG "$BENUTZER" | grep -qw libvirt; then
    echo "Der Benutzer $BENUTZER wird in die Gruppe libvirt aufgenommen."
    als_root usermod -aG libvirt "$BENUTZER"
    NEU_ANMELDEN=1
fi

# --- Hypervisor und NAT-Netzwerk ------------------------------------------------
als_root systemctl enable --now libvirtd >/dev/null 2>&1 || true
if ! als_root virsh -c "$VERBINDUNG" net-info default >/dev/null 2>&1; then
    warnung "Das libvirt-Netzwerk «default» fehlt. Ohne Netzwerk kann Debian nicht installiert werden."
else
    als_root virsh -c "$VERBINDUNG" net-autostart default >/dev/null
    if ! als_root virsh -c "$VERBINDUNG" net-list --name | grep -qx default; then
        als_root virsh -c "$VERBINDUNG" net-start default >/dev/null \
            || warnung "Das libvirt-Netzwerk «default» konnte nicht gestartet werden."
    fi
fi

# --- Neue Gruppe: alte VMs, ISOs, Ergebnisse und SSH-Schlüssel entfernen ---------
if [[ $NEUE_GRUPPE -eq 1 ]]; then
    mapfile -t VMS < <(als_root virsh -c "$VERBINDUNG" list --all --name | grep -E '^vm-' || true)
    ISOS=("$DOWNLOADS"/debian-*.iso "$DOWNLOADS"/SHA256SUMS*)
    vorhandene_isos=()
    for f in "${ISOS[@]}"; do [[ -e "$f" ]] && vorhandene_isos+=("$f"); done

    echo
    echo "Für die neue Gruppe wird gelöscht:"
    echo "  - Ordner $ERGEBNISSE (vorher einsammeln!)"
    if [[ ${#VMS[@]} -gt 0 ]]; then
        echo "  - VMs mit Festplatte und Schnappschüssen: ${VMS[*]}"
    else
        echo "  - (keine VMs, deren Name mit «vm-» beginnt)"
    fi
    for f in "${vorhandene_isos[@]}"; do echo "  - $f"; done
    echo "  - gespeicherte SSH-Schlüssel der Adressen 192.168.122.*"
    read -r -p "Wirklich löschen? Tippe «ja»: " antwort
    if [[ "$antwort" != "ja" ]]; then
        echo "Abgebrochen. Es wurde nichts gelöscht."
        exit 1
    fi

    for vm in "${VMS[@]}"; do
        als_root virsh -c "$VERBINDUNG" destroy "$vm" >/dev/null 2>&1 || true
        # Interne Schnappschüsse zuerst entfernen, sonst verweigert libvirt das Löschen.
        while read -r snap; do
            [[ -n "$snap" ]] && als_root virsh -c "$VERBINDUNG" snapshot-delete "$vm" "$snap" >/dev/null 2>&1 || true
        done < <(als_root virsh -c "$VERBINDUNG" snapshot-list "$vm" --name 2>/dev/null)
        if als_root virsh -c "$VERBINDUNG" undefine "$vm" --remove-all-storage --snapshots-metadata --nvram >/dev/null 2>&1 \
           || als_root virsh -c "$VERBINDUNG" undefine "$vm" --remove-all-storage --snapshots-metadata >/dev/null 2>&1; then
            echo "VM $vm gelöscht."
        else
            warnung "VM $vm konnte nicht gelöscht werden. Bitte im Virtual Machine Manager von Hand löschen."
        fi
    done
    rm -f -- "${vorhandene_isos[@]}"
    rm -rf -- "$ERGEBNISSE"
    if [[ -f "$HOME/.ssh/known_hosts" ]]; then
        for i in $(seq 2 254); do
            ssh-keygen -R "192.168.122.$i" >/dev/null 2>&1 || true
        done
        rm -f "$HOME/.ssh/known_hosts.old"
    fi
fi

# --- Ergebnis-Ordner -------------------------------------------------------------
mkdir -p "$ERGEBNISSE"

# --- Prüfungen ------------------------------------------------------------------
if [[ ! -e /dev/kvm ]]; then
    warnung "/dev/kvm fehlt: Die Virtualisierung (Intel VT-x / AMD-V) ist im BIOS/UEFI des Laptops ausgeschaltet. Bitte einschalten."
fi
ram_gib=$(awk '/MemTotal/ {printf "%d", $2/1024/1024 + 0.5}' /proc/meminfo)
if (( ram_gib < 6 )); then
    warnung "Der Laptop hat nur ca. ${ram_gib} GiB Arbeitsspeicher. Mit einer VM mit 2 GiB wird es eng (empfohlen: mindestens 8 GiB)."
fi
frei_gib=$(df -BG --output=avail /var/lib/libvirt/images 2>/dev/null | tail -1 | tr -dc '0-9')
if [[ -n "$frei_gib" ]] && (( frei_gib < 25 )); then
    warnung "In /var/lib/libvirt/images sind nur ${frei_gib} GiB frei. Die VM braucht bis zu 20 GiB (empfohlen: 25 GiB frei)."
fi
mkdir -p "$DOWNLOADS"
frei_dl=$(df -BG --output=avail "$DOWNLOADS" | tail -1 | tr -dc '0-9')
if (( frei_dl < 2 )); then
    warnung "In $DOWNLOADS sind nur ${frei_dl} GiB frei. Die ISO-Datei braucht ca. 1 GiB."
fi
if ! command -v firefox >/dev/null && ! command -v firefox-esr >/dev/null; then
    warnung "Firefox fehlt. Auf dem Aufgabenblatt wird Firefox benutzt (ein anderer Browser geht auch)."
fi

echo
echo "Fertig! Ergebnisse: $ERGEBNISSE"
if [[ -n "$(ls -A "$ERGEBNISSE")" ]]; then
    echo
    echo "Hinweis: In $ERGEBNISSE liegen noch Dateien (frühere Gruppe?)."
    echo "Zuerst einsammeln, dann den Befehl nochmals mit «--neue-gruppe» am Schluss ausführen."
fi
alte_vms=$(als_root virsh -c "$VERBINDUNG" list --all --name 2>/dev/null | grep -E '^vm-' | tr '\n' ' ' || true)
if [[ -n "$alte_vms" && $NEUE_GRUPPE -eq 0 ]]; then
    echo
    echo "Hinweis: Es gibt schon VMs von einer früheren Gruppe: $alte_vms"
    echo "Zum Löschen den Befehl nochmals mit «--neue-gruppe» am Schluss ausführen."
fi
for w in "${WARNUNGEN[@]}"; do
    echo
    echo "ACHTUNG: $w"
done
if [[ $NEU_ANMELDEN -eq 1 ]]; then
    echo
    echo "WICHTIG: Der Benutzer ist neu in der Gruppe libvirt. Das gilt erst nach einem"
    echo "         Neustart des Laptops (oder ab- und wieder anmelden). Ohne das fragt der"
    echo "         Virtual Machine Manager nach dem Administrator-Passwort."
fi

# Das Skript wird nach dem Einrichten nicht mehr gebraucht und löscht sich selbst.
# Beim Starten mit «bash <(curl …)» gibt es keine Datei, dann ist nichts zu tun.
# Ausnahme: im Git-Repository der Betreuungsperson, damit das Original erhalten bleibt.
if [[ -f "$SKRIPT" ]]; then
    if ! git -C "$(dirname "$SKRIPT")" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        rm -f -- "$SKRIPT"
    fi
fi
