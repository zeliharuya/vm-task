# vm-task

Fortgeschrittener Auftrag für Schnupperlehrlinge, die den
[Linux-Auftrag](https://github.com/zeliharuya/linux-task) gemacht haben. Dauer ca. 3 Stunden.
Die Schnupperlehrlinge laden die Debian-ISO herunter, prüfen die Prüfsumme, erstellen mit dem
**Virtual Machine Manager** eine VM, installieren Debian als Server ohne Desktop, steuern die VM
per **SSH**, richten darin einen **Webserver** ein und probieren **Schnappschüsse** aus.
Pro Aufgabe speichern sie eine Datei im Ordner `~/VM-Ergebnisse` auf dem Laptop. Der Dateiname
ist der Name der Aufgabe.

## Dateien

| Datei | Für wen | Inhalt |
|---|---|---|
| `aufgabenblatt.md` | Schnupperlehrlinge | Lesetexte, Aufgaben 0–10 und zwei freiwillige Zusatzaufgaben |
| `aufgabenblatt.pdf` | Schnupperlehrlinge | Das gleiche Aufgabenblatt zum Ausdrucken (A4, jede Aufgabe auf einer neuen Seite) |
| `setup.sh` | Betreuungsperson | Bereitet einen Laptop vor (Programme, Rechte, Netzwerk, Übungsdateien) |

Weiteres Material für die Betreuungsperson liegt nur lokal im Ordner `betreuung/` (siehe
`betreuung/README.md`). Dieser Ordner steht in `.gitignore` und wird nie ins öffentliche
Repository hochgeladen.

## Voraussetzungen

- Laptop mit **Debian 13** und Desktop, Internetzugang, Firefox
- Prozessor mit **Virtualisierung** (Intel VT-x / AMD-V), im BIOS/UEFI eingeschaltet
- mindestens **8 GB Arbeitsspeicher** (die VM bekommt 2 GiB)
- mindestens **25 GB frei** unter `/var/lib/libvirt/images`
- ein Benutzer mit `sudo`-Rechten zum Vorbereiten

## Vorbereitung

Bereite jeden Laptop **vor** dem Austeilen vor. Melde dich mit dem Benutzer an, mit dem die
Schnupperlehrlinge arbeiten, öffne ein Terminal und führe diesen Befehl aus:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/zeliharuya/vm-task/main/setup.sh || wget -qO- https://raw.githubusercontent.com/zeliharuya/vm-task/main/setup.sh)
```

Der Befehl lädt `setup.sh` herunter und führt es direkt aus. Es bleibt keine Datei auf dem Laptop
zurück. Das Skript fragt nach dem sudo-Passwort und

- installiert den Virtual Machine Manager, QEMU/KVM, libvirt, nano, curl und wget, falls sie fehlen,
- nimmt den Benutzer in die Gruppe `libvirt` auf (damit er ohne Passwort VMs verwalten darf),
- startet das NAT-Netzwerk `default` von libvirt und startet es künftig automatisch,
- legt `~/vm-auftrag` (Übungsdateien) und `~/VM-Ergebnisse` (leer, für die Antworten) an,
- warnt, wenn die Virtualisierung ausgeschaltet ist, zu wenig Arbeitsspeicher oder Platz da ist
  oder noch Dateien bzw. VMs von einer früheren Gruppe da sind.

Am Schluss muss **«Fertig!»** stehen. Steht darunter **«WICHTIG: … neu in der Gruppe libvirt»**,
musst du den Laptop **neu starten**, sonst fragt der Virtual Machine Manager nach einem
Administrator-Passwort. Lies auch alle Zeilen mit **ACHTUNG**.

Für eine neue Gruppe hängst du `--neue-gruppe` an den Befehl an (nach der letzten Klammer). Das
löscht nach einer Rückfrage `~/VM-Ergebnisse`, alle VMs, deren Name mit `vm-` beginnt, die
heruntergeladenen Debian-ISOs und die gespeicherten SSH-Schlüssel der VMs. Also vorher
einsammeln.

Wenn du das Repository lieber klonst: `bash vm-task/setup.sh` ausführen und danach den Ordner
mit `rm -rf vm-task` wieder löschen. In einem Git-Repository löscht sich `setup.sh` nicht selbst.

## Ergebnisse einsammeln

Zum Beispiel den Ordner `~/VM-Ergebnisse` von jedem Laptop auf einen USB-Stick kopieren und dabei
nach der Person benennen:

```bash
cp -r ~/VM-Ergebnisse /media/$USER/<STICK>/VM-Ergebnisse_Anna_Muster
```

Danach `setup.sh --neue-gruppe` ausführen (siehe oben), damit die nächste Gruppe die Antworten
und die VMs nicht sieht.

## Aufgabenblatt als PDF

`aufgabenblatt.pdf` ist fertig zum Ausdrucken. Wenn du `aufgabenblatt.md` änderst, musst du das PDF
neu erstellen, z. B. so:

```bash
pandoc aufgabenblatt.md -o aufgabenblatt.pdf
```
