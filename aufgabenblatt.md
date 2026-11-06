# VM-Auftrag: Ein Computer im Computer

**Für:** Schnupperlehrlinge, die den Linux-Auftrag gemacht haben  **Zeit:** ca. 2½ Stunden
**Vorwissen:** Linux-Auftrag (Terminal, `cd`, `ls`, `cat`, `nano`, `>` und `>>`)

In diesem Auftrag baust du dir deinen eigenen Server: Du lädst Debian Linux herunter, installierst
es in einer **virtuellen Maschine** und steuerst diesen Server danach von deinem Laptop aus. Am
Schluss läuft darauf sogar deine eigene Webseite.

Alles, was du wissen musst, steht auf diesen Blättern. **Lies jeden Text genau durch, bevor du
etwas tippst oder klickst.** Wie beim Linux-Auftrag wird auch geprüft, ob du verstanden hast, was
du gelesen hast. Einige Fallen sind absichtlich eingebaut.

---

## Wichtige Regeln – bitte zuerst lesen!

1. Alle deine Ergebnisse speicherst du im Ordner **`VM-Ergebnisse`** auf deinem Laptop
   (nicht in der virtuellen Maschine!). Dieser Ordner ist schon vorbereitet.
2. Jede Aufgabe hat einen **Namen**, zum Beispiel `aufgabe1_virtualisierung`.
   Deine Datei für diese Aufgabe heisst genau gleich, mit **`.txt`** am Ende:
   `aufgabe1_virtualisierung.txt`
3. In der **ersten Zeile** jeder Ergebnisdatei steht immer dein **Vorname und Nachname**.
4. Schreibe Antworten in **ganzen Sätzen**, wenn nach einer Erklärung gefragt wird.
5. Schreibe **nie ein Passwort** in eine Ergebnisdatei.
6. Wenn du nicht weiterkommst: Lies den Text **nochmals** durch. Hilft das nicht, frag die
   Betreuungsperson.

### Deine Namen für diesen Auftrag

Du brauchst im Auftrag mehrmals deinen Vornamen in einer «Computer-Schreibweise»: nur
**Kleinbuchstaben**, **keine Umlaute** und **keine Leerzeichen**. Aus ä wird ae, aus ö wird oe,
aus ü wird ue.

| Beispiel        | Benutzername | Name der VM    |
|-----------------|--------------|----------------|
| Anna Muster     | `anna`       | `vm-anna`      |
| Jörg Beispiel   | `joerg`      | `vm-joerg`     |
| Lea-Sophie Test | `leasophie`  | `vm-leasophie` |

Überlege dir jetzt deinen Benutzernamen und den Namen deiner VM und merke sie dir.

In allen Befehlen auf diesen Blättern steht als Beispiel `anna` und `vm-anna`.
**Du ersetzt das immer durch deine eigenen Namen.**

### Übersicht

| Nr. | Name der Aufgabe (= Dateiname)  | Thema                                  | Zeit   |
|-----|---------------------------------|----------------------------------------|--------|
| 0   | –                               | Vorbereitung                           | 5 Min  |
| 1   | `aufgabe1_virtualisierung`      | Was ist eine VM? Wie stark ist dein Laptop? | 20 Min |
| 2   | `aufgabe2_iso`                  | Debian herunterladen und prüfen        | 20 Min |
| 3   | `aufgabe3_vm_erstellen`         | Die virtuelle Maschine erstellen       | 15 Min |
| 4   | `aufgabe4_installation`         | Debian installieren                    | 45 Min |
| 5   | `aufgabe5_ssh`                  | Anmelden und fernsteuern mit SSH       | 25 Min |
| 6   | `aufgabe6_webserver`            | Deine eigene Webseite                  | 20 Min |
| 7   | `aufgabe7_rueckblick`           | Was hast du gelernt?                   | 10 Min |
| ★   | `zusatz_schnappschuss`          | Freiwillig: Zurück in die Vergangenheit |   –    |
| ★   | `bonus_virsh`                   | Freiwillig: VMs mit Befehlen steuern   |   –    |

Die Aufgaben 0 bis 7 sind Pflicht. Die zwei Aufgaben mit ★ machst du nur, wenn du vorher fertig
bist. Die Aufgaben bauen aufeinander auf: Mach sie **der Reihe nach**.

---

## Aufgabe 0 – Vorbereitung (keine Datei)

### Wiederholung aus dem Linux-Auftrag

| Was                        | Wie                                                           |
|----------------------------|---------------------------------------------------------------|
| Terminal öffnen            | Menü bzw. Suche → **Terminal**                                |
| Datei bearbeiten           | `nano ~/VM-Ergebnisse/dateiname.txt`                          |
| In nano speichern          | `Ctrl` + `O`, danach Enter                                    |
| nano verlassen             | `Ctrl` + `X`                                                  |
| Ergebnis in Datei, **neu** | `befehl > datei` (löscht, was vorher in der Datei war)        |
| Ergebnis **anhängen**      | `befehl >> datei` (was vorher drin war, bleibt erhalten)      |
| Letzten Befehl holen       | Pfeiltaste `↑`                                                |
| Namen ergänzen             | Tabulator-Taste `⇥`                                           |
| Einfügen im Terminal       | `Ctrl` + `Shift` + `V`                                        |

| Zeichen | Auf der Schweizer Tastatur                                        |
|---------|-------------------------------------------------------------------|
| `~`     | `AltGr` + `^` (Taste rechts neben `'`), danach die **Leertaste**  |
| `@`     | `AltGr` + `2`                                                     |
| `\|`    | `AltGr` + `7`                                                     |
| `<` `>` | Taste links neben `Y`, für `>` zusätzlich `Shift`                 |

Kontrolliere, ob der Ordner für deine Ergebnisse da ist:

```
ls ~/VM-Ergebnisse
```

Es darf **keine Fehlermeldung** erscheinen. Der Ordner ist am Anfang leer, also erscheint auch
sonst nichts. Wenn eine Fehlermeldung kommt: Betreuungsperson fragen.

---

## Aufgabe 1 – `aufgabe1_virtualisierung`

### Lesetext: Ein Computer im Computer

Eine **virtuelle Maschine** (kurz **VM**) ist ein Computer, der nicht aus echten Teilen besteht,
sondern nur als **Programm** auf einem echten Computer läuft. Die VM hat einen eigenen Prozessor,
eigenen Arbeitsspeicher, eine eigene Festplatte und eine eigene Netzwerkkarte. Aber all das ist
nur **vorgetäuscht**: In Wirklichkeit leiht sich die VM ein Stück vom echten Computer aus. Ihre
Festplatte ist zum Beispiel nur eine grosse **Datei** auf der Festplatte des echten Computers.

Den echten Computer nennt man **Host** (englisch für Gastgeber). Die VM nennt man **Gast**. Auf
einem Host können gleichzeitig **mehrere** Gäste laufen, jeder mit seinem eigenen Betriebssystem.

Damit das funktioniert, braucht es einen **Hypervisor**. Er verteilt die Teile des Hosts an die
Gäste und passt auf, dass sie sich nicht gegenseitig stören. Man kann es mit einem
**Mehrfamilienhaus** vergleichen: Das Haus ist der Host, die Wohnungen sind die VMs, und die
Hausverwaltung ist der Hypervisor. Sie entscheidet, wie gross jede Wohnung ist. Mehr Platz, als
das Haus hat, kann sie aber nicht verteilen.

Unter Linux heisst der Hypervisor **KVM**. Er ist direkt im **Kern von Linux** eingebaut. Mit dem
Programm **Virtual Machine Manager** (auf Deutsch «Virtuelle Maschinenverwaltung») kannst du die
VMs mit der Maus erstellen und steuern.

Warum benutzt man VMs? Wenn in einer VM etwas kaputtgeht, ist **nur die VM** kaputt, der Host
läuft normal weiter. Ausserdem kann eine Firma auf **einem** starken Server viele VMs laufen
lassen, statt viele Server zu kaufen. Fast alles aus der **Cloud** läuft in VMs.

### Wie stark ist dein Laptop?

Was die VM bekommt, fehlt dem Host, solange die VM läuft. Darum musst du wissen, wie viel dein
Laptop hergeben kann. Ausserdem muss der Prozessor **Virtualisierung** unterstützen, sonst ist
die VM sehr langsam. Intel nennt das **VT-x**, AMD nennt es **AMD-V**. Kann der Prozessor das und
ist es eingeschaltet, gibt es auf dem Laptop die Datei **`/dev/kvm`**. Über diese Datei
benutzen Programme den Hypervisor KVM.

| Befehl                                  | Was er zeigt                                                   |
|-----------------------------------------|----------------------------------------------------------------|
| `nproc`                                 | die Anzahl **Prozessor-Kerne**                                 |
| `free -h`                               | den **Arbeitsspeicher** (RAM). Wichtig ist die Zeile `Speicher:` (bzw. `Mem:`) und die Spalte `gesamt` (bzw. `total`). |
| `ls -l /dev/kvm`                        | zeigt die Datei `/dev/kvm`, wenn es sie gibt. Gibt es sie **nicht**, erscheint `No such file or directory` (bzw. `Datei oder Verzeichnis nicht gefunden`). |

Das `-h` bei `free` heisst «human» (= für Menschen lesbar). Statt riesigen Zahlen siehst du
dann z. B. `15Gi`. `Gi` steht für Gibibyte, das ist fast das Gleiche wie Gigabyte (GB).

### Aufträge

1. Schreibe deinen Namen in die Ergebnisdatei (Ersetze *Vorname Nachname* durch **deinen** Namen):
   ```
   echo "Vorname Nachname" > ~/VM-Ergebnisse/aufgabe1_virtualisierung.txt
   ```
2. Hänge nacheinander die Ergebnisse der **drei** Befehle aus dem Kasten an diese Datei an.
3. Öffne die Datei mit nano. Kontrolliere, ob dein Name noch in der ersten Zeile steht.
   Beantworte unten diese Fragen. Schreibe vor jede Antwort die Nummer (z. B. `1)`).
   1. Erkläre **in deinen eigenen Worten** (nicht abschreiben!), was eine virtuelle Maschine ist.
   2. In diesem Auftrag: Was ist der **Host** und was ist der **Gast**?
   3. Richtig oder falsch? Schreibe **R** oder **F** und begründe mit einem Satz.
      - a) Wenn der Host 8 GB Arbeitsspeicher hat, kann man einer VM 16 GB geben.
      - b) Wenn ich in der VM aus Versehen alle Dateien lösche, sind auch die Dateien auf dem
           Host weg.
   4. Wie heisst der **Hypervisor** unter Linux, und wie heisst das **Programm**, mit dem du heute
      die VM erstellst? Antworte mit genau **zwei Namen**.
   5. Wie viele Kerne und wie viel Arbeitsspeicher **insgesamt** hat dein Laptop?
   6. Kann der Prozessor deines Laptops Virtualisierung? Woran erkennst du das?
   7. Deine VM bekommt **2 GiB** Arbeitsspeicher. Wie viel bleibt dem Laptop noch, solange die
      VM läuft?

---

## Aufgabe 2 – `aufgabe2_iso`

### Lesetext: ISO-Dateien und Prüfsummen

Früher hat man ein Betriebssystem von einer **CD** installiert. Heute lädt man stattdessen eine
**ISO-Datei** herunter. Das ist eine genaue Kopie einer CD in einer einzigen Datei. Die VM kann
sie benutzen, als wäre eine echte CD eingelegt. Wir nehmen die kleinste ISO-Datei von Debian:
**netinst**. Sie enthält nur das Nötigste, alles andere wird während der Installation aus dem
Internet geladen.

**Woher lädt man Software herunter?** Immer von der **offiziellen Webseite** der Firma oder des
Projekts, bei Debian also von **www.debian.org**. Download-Portale wie chip.de oder softonic, oder
Werbung, die bei einer Suche ganz oben erscheint, verpacken Programme manchmal in eigene
Installationsprogramme mit Werbung oder sogar Schadprogrammen. Oft haben sie auch alte Versionen.
Kontrolliere deshalb immer die **Adresse** in der Adresszeile des Browsers.

Beim Herunterladen kann trotzdem etwas schiefgehen: Die Datei ist unvollständig, oder jemand Böses
hat sie unterwegs verändert und ein Schadprogramm eingebaut. Deshalb veröffentlicht Debian zu
jeder ISO-Datei eine **Prüfsumme**. Eine Prüfsumme ist wie ein **Fingerabdruck** einer Datei: eine
lange Zeichenkette, die aus dem ganzen Inhalt berechnet wird. Ändert sich in der Datei auch nur
**ein einziges Zeichen**, kommt ein **komplett anderer** Fingerabdruck heraus. Debian benutzt dafür
das Verfahren **SHA-512**. Du berechnest die Prüfsumme deiner Datei und vergleichst sie mit der
Prüfsumme, die auf der Webseite von Debian steht. Sind beide **gleich**, ist die Datei in Ordnung.

| Befehl                         | Was er macht                                                          |
|--------------------------------|-----------------------------------------------------------------------|
| `sha512sum datei`              | berechnet die Prüfsumme der Datei.                                    |
| `ls -lh datei`                 | zeigt Informationen über die Datei an, unter anderem ihre **Grösse**. |

### Aufträge

1. **Die offizielle Download-Seite finden:** Öffne den **Firefox** und suche selbst nach
   **Debian download**. Öffne nur ein Ergebnis, dessen Adresse mit **www.debian.org** beginnt
   (keine Werbung, keine Download-Portale). Du suchst die Seite mit dem Titel
   **Downloading Debian**. Darauf steht: «This is Debian 13 … netinst, for 64-bit PC (amd64)».
   Wenn du stattdessen auf der Startseite von Debian landest: Tippe in der Adresszeile hinter
   `www.debian.org` noch `/download` und drücke Enter.
2. **Download starten** (dauert einige Minuten): Klicke auf der Seite auf den Namen der ISO-Datei.
   Er endet auf `-amd64-netinst.iso`. Firefox speichert sie im Ordner `Downloads`.
3. **Während des Wartens:** Schreibe deinen Namen in die Datei `~/VM-Ergebnisse/aufgabe2_iso.txt`
   und hänge die Adresse der Download-Seite an (ersetze die Adresse durch die, die **bei dir** in
   der Adresszeile steht):
   ```
   echo "https://www.debian.org/download" >> ~/VM-Ergebnisse/aufgabe2_iso.txt
   ```
   Tippe dann diese zwei Befehle (einmal grosses **H**, einmal kleines **h**) und vergleiche:
   ```
   echo Hallo | sha512sum
   echo hallo | sha512sum
   ```
4. Wenn der Download der ISO-Datei fertig ist: Wechsle im Terminal mit `cd ~/Downloads` in den
   Ordner `Downloads`. Hänge Informationen über die ISO-Datei an. Der Stern `*` steht für
   «beliebige Zeichen», so musst du die Versionsnummer nicht abtippen:
   ```
   ls -lh debian-*-amd64-netinst.iso >> ~/VM-Ergebnisse/aufgabe2_iso.txt
   ```
5. Berechne die Prüfsumme der ISO-Datei und hänge sie an (das dauert ein paar Sekunden):
   ```
   sha512sum debian-*-amd64-netinst.iso >> ~/VM-Ergebnisse/aufgabe2_iso.txt
   ```
   Schau dir die Prüfsumme mit `cat ~/VM-Ergebnisse/aufgabe2_iso.txt` an.
6. **Vergleichen:** Auf der Download-Seite steht unter dem Namen der ISO-Datei
   «Download checksum: **SHA512SUMS**». Klicke auf `SHA512SUMS`. Firefox zeigt eine kurze Liste:
   Jede Zeile ist eine Prüfsumme und dahinter der Name einer ISO-Datei. Suche die Zeile mit
   **deiner** ISO-Datei und vergleiche sie mit deiner Prüfsumme im Terminal. Es reicht, die
   **ersten 10** und die **letzten 10** Zeichen zu vergleichen. Sind sie nicht gleich:
   Betreuungsperson fragen.
7. Öffne die Ergebnisdatei mit nano und beantworte unten:
   - a) Was ist dir bei `Hallo` und `hallo` aufgefallen? Was sagt dir das über Prüfsummen?
   - b) Wie gross ist die ISO-Datei?
   - c) Ist deine Prüfsumme gleich wie die auf der Webseite? Schreibe die **ersten 10 Zeichen**
     der Prüfsumme auf der Webseite ab.
   - d) Was hättest du gemacht, wenn die Prüfsummen **nicht** gleich gewesen wären? Warum?
   - e) Warum lädt man Debian von www.debian.org herunter und nicht von einem Download-Portal?

---

## Aufgabe 3 – `aufgabe3_vm_erstellen`

### Lesetext: Die VM einrichten

Jetzt baust du die VM mit dem **Virtual Machine Manager**. Die VM bekommt eine eigene Adresse in
einem **privaten Netzwerk**, das nur auf deinem Laptop existiert. Ins Internet kommt sie über
deinen Laptop, so wie dein Handy zu Hause über den WLAN-Router. Diese Art von Netzwerk heisst
**NAT**.

| Einstellung        | Wert                                                     |
|--------------------|----------------------------------------------------------|
| Installation       | Lokales Installationsmedium (ISO-Abbild oder CDROM)      |
| ISO-Datei          | die Debian-ISO-Datei aus `Downloads`                     |
| Betriebssystem     | automatisch erkannt: **Debian 13**                       |
| Speicher           | **2048** MiB                                             |
| CPUs               | **2**                                                    |
| Festplatte         | **20** GiB                                               |
| Name               | **`vm-anna`** (mit **deinem** Vornamen, siehe Seite 1)   |
| Netzwerk           | Virtuelles Netzwerk 'default': NAT                       |

### Aufträge

1. Starte über das Menü bzw. die Suche das Programm **Virtuelle Maschinenverwaltung** (bzw.
   «Virtual Machine Manager»). Im Fenster siehst du die Zeile **QEMU/KVM**.
2. Klicke oben links auf das erste Symbol (Bildschirm mit einem Stern, «Neue virtuelle Maschine
   erstellen»). Ein Assistent führt dich in **5 Schritten** durch die Einrichtung:
   - **Schritt 1 von 5:** Wähle **Lokales Installationsmedium (ISO-Abbild oder CDROM)**.
     Klicke auf **Weiter**.
   - **Schritt 2 von 5:** Klicke auf **Durchsuchen …**. Klicke im neuen Fenster **unten** auf
     **Browse Local**, gehe in den Ordner `Downloads`, wähle die ISO-Datei und klicke auf
     **Öffnen**. Darunter muss **Debian 13** stehen. Klicke auf **Weiter**.
     Wenn eine Meldung kommt, dass der Emulator **keine Suchberechtigungen** für den Pfad hat:
     Klicke auf **Ja**.
   - **Schritt 3 von 5:** Trage **Speicher** und **CPUs** aus der Tabelle ein. **Weiter**.
   - **Schritt 4 von 5:** Trage die Grösse der Festplatte aus der Tabelle ein. **Weiter**.
   - **Schritt 5 von 5:** Lösche den vorgeschlagenen Namen und trage **deinen** VM-Namen ein.
     Kontrolliere alle Angaben noch einmal mit der Tabelle und klicke dann auf **Fertig**.
3. Ein neues Fenster öffnet sich: der **Bildschirm deiner VM** mit dem Startmenü von Debian.
   **Sofort** in das Fenster klicken und **Enter** drücken (**Graphical install** ist schon
   ausgewählt). Das Startmenü wartet nämlich nicht lange und startet sonst von selbst etwas
   anderes. Danach erscheint **Select a language**. Dieser Bildschirm wartet, so lange du willst.
   **Klicke dort noch nichts an!** Mach zuerst die Aufträge 4 und 5.
4. Schreibe deinen Namen in die Datei `~/VM-Ergebnisse/aufgabe3_vm_erstellen.txt` und hänge die
   Informationen über deine VM an (mit **deinem** VM-Namen am Schluss):
   ```
   virsh -c qemu:///system dominfo vm-anna >> ~/VM-Ergebnisse/aufgabe3_vm_erstellen.txt
   ```
   `virsh` ist das Terminal-Werkzeug für VMs. **Domain** ist bei `virsh` ein anderes Wort für VM.
   Bei einer Fehlermeldung: Schau genau, ob du den Namen richtig geschrieben hast.
5. Öffne die Datei mit nano und beantworte unten:
   - a) Wie viele CPUs hat deine VM laut `dominfo`?
   - b) Bei `Max Speicher` (bzw. `Max memory`) steht der Arbeitsspeicher in **KiB**. Rechne ihn
        in MiB um (1 MiB = 1024 KiB). Stimmt er mit der Tabelle überein?
   - c) Die VM startet von der ISO-Datei und nicht von ihrer Festplatte. Warum?

---

## Aufgabe 4 – `aufgabe4_installation`

### Lesetext: Was bei der Installation passiert

**root und sudo:** Unter Linux gibt es einen besonderen Benutzer mit dem Namen **root**. root ist
der **Administrator** und darf alles, auch das ganze System kaputtmachen. Darum arbeitet man als
normaler Benutzer und setzt nur bei wichtigen Befehlen **`sudo`** davor. Dann wird nur **dieser
eine Befehl** mit Administratorrechten ausgeführt, und Linux fragt vorher nach **deinem**
Passwort. Im Installationsprogramm gilt: Wenn du für root **kein** Passwort eingibst, ist root
gesperrt und **dein** Benutzer darf stattdessen `sudo` benutzen. Genau das wollen wir.

**Partitionieren:** Bevor ein Betriebssystem auf eine Festplatte kommt, wird die Festplatte
eingeteilt, so wie man einen leeren Schrank mit Fächern einteilt. Dabei wird **alles gelöscht**,
was vorher auf der Festplatte war. Das Installationsprogramm sieht aber nur die Festplatte, die es
vor sich hat. Bei einem echten Computer wäre das die echte Festplatte mit allen Fotos.

**Server ohne Desktop:** Wir installieren die VM wie einen echten **Server** **ohne**
Desktop-Umgebung (also ohne Fenster und Maus). Ein Server steht meistens in einem Rechenzentrum,
und niemand sitzt davor. Man steuert ihn aus der Ferne mit Text-Befehlen. Ohne Desktop braucht
die VM ausserdem **viel weniger Arbeitsspeicher**, und die Installation geht schneller.
Stattdessen installieren wir einen **SSH-Server**, damit du die VM in Aufgabe 5 fernsteuern kannst.

**Englisch:** Du installierst Debian auf **Englisch**, so wie die meisten Server auf der Welt.
Fehlermeldungen auf Englisch findet man im Internet viel leichter. Nur die **Tastatur** stellst du
auf **Schweizerdeutsch** (Swiss German), damit die Tasten stimmen.

### Aufträge

Klicke in das Fenster deiner VM. Arbeite die Tabelle **Zeile für Zeile** ab. Mit **Continue**
(unten rechts) kommst du zur nächsten Frage, mit **Go Back** oft eine Frage zurück. Fragen, die
**nicht** in der Tabelle stehen, beantwortest du mit dem, was schon ausgewählt ist.

> **Maus gefangen?** Wenn die Maus im Fenster der VM festhängt, drückst du `Ctrl` + `Alt`
> (beide links). Dann ist die Maus wieder frei.

| Nr. | Frage / Bildschirm (englisch)                          | Deine Antwort                                         |
|-----|--------------------------------------------------------|-------------------------------------------------------|
| 1   | Debian GNU/Linux installer menu                        | schon erledigt (Aufgabe 3, Auftrag 3)                 |
| 2   | Select a language                                      | **English**                                           |
| 3   | Select your location                                   | **other**, danach **Europe**, danach **Switzerland**  |
| 4   | Configure locales                                      | **United States – en_US.UTF-8**                       |
| 5   | Configure the keyboard                                 | **Swiss German** (nicht American English!)            |
| 6   | Hostname                                               | dein VM-Name, z. B. **`vm-anna`**                     |
| 7   | Domain name                                            | **leer lassen**                                       |
| 8   | Root password (und Re-enter password to verify)        | **beide Felder leer lassen!** (siehe Lesetext)        |
| 9   | Full name for the new user                             | dein Vor- und Nachname                                |
| 10  | Username for your account                              | dein Benutzername, z. B. **`anna`** (kontrollieren!)  |
| 11  | Choose a password for the new user (und Re-enter …)    | ein Passwort, das du dir **merken** kannst            |
| 12  | Partitioning method                                    | **Guided – use entire disk**                          |
| 13  | Select disk to partition                               | die einzige Festplatte (**vda**, ca. 21 GB)           |
| 14  | Partitioning scheme                                    | **All files in one partition** …                      |
| 15  | Übersicht der Partitionen                              | **Finish partitioning and write changes to disk**     |
| 16  | Write the changes to disks?                            | **Yes** – Achtung, vorausgewählt ist **No**!          |
| –   | *Installing the base system (einige Minuten)*          | *warten, Fragen unten bearbeiten*                     |
| 17  | Scan extra installation media?                         | **No**                                                |
| 18  | Debian archive mirror country / Debian archive mirror  | **Switzerland**, danach **deb.debian.org**            |
| 19  | HTTP proxy information                                 | **leer lassen**                                       |
| 20  | Participate in the package usage survey?               | **No**                                                |
| 21  | Software selection                                     | siehe Kasten unten                                    |
| –   | *Select and install software (einige Minuten)*         | *warten, Fragen unten bearbeiten*                     |
| 22  | Install the GRUB boot loader to your primary drive?    | **Yes**, danach **/dev/vda** auswählen                |
| 23  | Installation complete                                  | **Continue**. Die VM startet neu.                     |

> **Software selection (Nr. 21) – genau lesen!**
> Es soll **nur** bei diesen zwei Einträgen ein Häkchen sein:
> **SSH server** und **standard system utilities**.
> Entferne das Häkchen bei **Debian desktop environment** und bei **GNOME**.
> Alle anderen Einträge bleiben ohne Häkchen.

Nach dem Neustart erscheint ein schwarzer Bildschirm mit weisser Schrift und der Zeile
`vm-anna login:`. Dann ist die Installation fertig.

**Während des Wartens:** Erstelle die Datei `~/VM-Ergebnisse/aufgabe4_installation.txt`
(erste Zeile: dein Name) und beantworte:

- a) Welchen **Rechnernamen** (hostname) und welchen **Benutzernamen** hast du gewählt?
     (**Kein** Passwort hinschreiben!)
- b) Das Installationsprogramm warnt, dass alle Daten auf der Festplatte gelöscht werden.
     Warum ist das für deinen Laptop **ungefährlich**?
- c) Warum hast du das Root-Passwort **leer** gelassen? Was darf dein Benutzer deshalb?
- d) Nenne **zwei Gründe** aus dem Text, warum wir **keine** Desktop-Umgebung installieren.

---

## Aufgabe 5 – `aufgabe5_ssh`

### Lesetext: Anmelden und fernsteuern

Jedes Gerät in einem Netzwerk hat eine **IP-Adresse**, z. B. `192.168.122.57`. Über diese Adresse
finden sich die Geräte, so wie ein Brief über die Postadresse ankommt. Deine VM hat ihre
IP-Adresse beim Starten automatisch bekommen. **Jede VM hat eine andere.** Du findest sie so
heraus:

| Wo du tippst | Befehl              | Was du siehst                                                  |
|--------------|---------------------|----------------------------------------------------------------|
| in der VM    | `hostname -I`       | die IP-Adresse(n) der VM. Deine ist die, die mit `192.168.` beginnt. |
| auf dem Laptop | `virsh -c qemu:///system domifaddr vm-anna` | eine Tabelle; die IP-Adresse steht in der Spalte `Address` vor dem `/24`. |

In allen Befehlen auf diesen Blättern steht `192.168.122.57` nur als **Beispiel**. Du ersetzt es
immer durch die IP-Adresse **deiner** VM.

Im Linux-Auftrag hast du gelesen, dass man Server aus der Ferne mit Text-Befehlen steuert. Das
Werkzeug dafür heisst **SSH** («Secure Shell»). Mit SSH öffnest du im Terminal deines Laptops ein
Terminal **auf einem anderen Computer**. Alles, was durchs Netzwerk geht, ist **verschlüsselt**.

```
ssh benutzer@adresse
```

- `benutzer` ist dein Benutzername **in der VM**. `@` heisst «at» (= «bei»).
- Beim **allerersten** Verbinden fragt SSH: `Are you sure you want to continue connecting
  (yes/no/[fingerprint])?` Hier musst du das ganze Wort **`yes`** ausschreiben.
- Beim Passwort erscheinen **keine Zeichen**, auch keine Sternchen. Das ist normal.
- Mit **`exit`** beendest du die Verbindung und bist wieder auf deinem Laptop.

**Wo bin ich?** Schau **vor jedem Befehl** auf die Eingabeaufforderung. Steht dort `vm-anna`,
tippst du in der VM.

**Ein einzelner Befehl:** Schreibst du einen Befehl hinter die Adresse, führt SSH nur diesen
Befehl in der VM aus und kommt sofort zurück. Das Ergebnis erscheint **auf deinem Laptop**, also
kannst du es mit `>>` in eine Datei auf dem Laptop schreiben:

```
ssh anna@192.168.122.57 hostname >> ~/VM-Ergebnisse/aufgabe5_ssh.txt
```

### Aufträge

1. Klicke in das Fenster der VM. Melde dich mit deinem Benutzernamen und Passwort an.
2. Finde die IP-Adresse deiner VM heraus: Tippe **in der VM** `hostname -I`.
   Du musst sie nicht aufschreiben: Wenn du sie vergisst, schaust du einfach wieder mit
   `hostname -I` in der VM oder mit `virsh … domifaddr` auf dem Laptop nach.
   Kontrolliere sie danach im Terminal **deines Laptops** mit `virsh … domifaddr` (siehe
   Tabelle, mit **deinem** VM-Namen). Es muss die gleiche Adresse herauskommen.
3. Schreibe auf dem **Laptop** deinen Namen in die Datei `~/VM-Ergebnisse/aufgabe5_ssh.txt`.
4. Verbinde dich im Terminal deines Laptops per SSH mit der VM. Setze **deinen** Benutzernamen
   und **deine** IP-Adresse aus Auftrag 2 ein, z. B.:
   ```
   ssh anna@192.168.122.57
   ```
   Tippe in der VM `hostname` und beende die Verbindung mit `exit`.
5. Hänge jetzt die Ergebnisse dieser **drei** Befehle **aus der VM** an deine Ergebnisdatei an
   (SSH mit einem einzelnen Befehl, siehe Lesetext). Der erste sieht so aus, mit **deinem**
   Benutzernamen und **deiner** IP-Adresse:
   ```
   ssh anna@192.168.122.57 hostname >> ~/VM-Ergebnisse/aufgabe5_ssh.txt
   ```
   Danach das Gleiche mit `free -h` und mit `groups` statt `hostname`. **Tipp:** Mit `↑` holst du
   den letzten Befehl zurück und musst nur den Befehl in der Mitte ändern.
   `groups` zeigt, in welchen **Gruppen** dein Benutzer ist. Eine Gruppe ist eine Liste von
   Benutzern mit gleichen Rechten.
6. Öffne die Datei mit nano und beantworte unten:
   - a) Wie lautet die IP-Adresse deiner VM?
   - b) Vergleiche den Arbeitsspeicher der VM mit deinem Laptop aus Aufgabe 1. Warum hat die VM
        weniger?
   - c) Woran erkennst du, ob du gerade auf dem Laptop oder in der VM tippst?
   - d) Dein Benutzer ist in der Gruppe `sudo`. Warum? (Denk an Aufgabe 4.)

> Lass die VM ab jetzt einfach laufen. Du kannst ihr Fenster verkleinern, aber **schliess** die VM
> nicht und fahr sie nicht herunter.

---

## Aufgabe 6 – `aufgabe6_webserver`

### Lesetext: Programme installieren und Webseiten anbieten

Unter Linux installiert man Programme mit einer **Paketverwaltung**, ähnlich wie mit einem App
Store. Unter Debian heisst sie **apt**. Programme installieren verändert das System, darum
braucht es `sudo`.

| Befehl                    | Was er macht                                                       |
|---------------------------|--------------------------------------------------------------------|
| `sudo apt update`         | lädt die **aktuelle Liste** aller Pakete herunter.                 |
| `sudo apt install paket`  | lädt das Paket herunter und **installiert** es.                    |

Ein **Webserver** ist ein Programm, das Webseiten an Browser ausliefert. Wir installieren den
Webserver **nginx** (ausgesprochen «engine-x»). Er liefert die Dateien aus dem Ordner
**`/var/www/html`** aus. Die Startseite heisst `index.html`. Dieser Ordner gehört dem System,
darum braucht es auch zum Bearbeiten `sudo`. Webseiten werden in **HTML** geschrieben:
`<h1>…</h1>` ist eine Überschrift, `<p>…</p>` ein Absatz.

Mit **`curl`** holst du eine Webseite im Terminal ab statt im Browser.

### Aufträge

1. Verbinde dich per SSH mit deiner VM (so, dass du in der VM bleibst).
2. Lade die Paketliste herunter und installiere das Paket `nginx`. Wenn `apt` fragt, ob du
   fortfahren möchtest, drückst du `Y` (für «yes») und Enter.
3. Öffne auf dem Laptop den Firefox und tippe `http://` und die IP-Adresse deiner VM aus
   Aufgabe 5 ein, z. B. `http://192.168.122.57`. Es erscheint **Welcome to nginx!**
4. Erstelle in der VM deine eigene Startseite mit `sudo nano /var/www/html/index.html`.
   Tippe diesen Text ab und ersetze die Teile in Grossbuchstaben:
   ```
   <meta charset="utf-8">
   <h1>Willkommen auf VM-NAME</h1>
   <p>Diese Seite hat VORNAME NACHNAME gemacht.</p>
   ```
   Die erste Zeile sorgt dafür, dass Umlaute wie ä, ö, ü richtig angezeigt werden.
   Speichern und nano verlassen. Lade die Seite im Firefox neu (`F5`).
5. Beende die SSH-Verbindung. Schreibe auf dem **Laptop** deinen Namen in die Datei
   `~/VM-Ergebnisse/aufgabe6_webserver.txt` und hänge die Webseite an (`-s` = «silent», still;
   mit **deiner** IP-Adresse):
   ```
   curl -s http://192.168.122.57 >> ~/VM-Ergebnisse/aufgabe6_webserver.txt
   ```
6. Öffne die Datei mit nano und beantworte unten:
   - a) Warum brauchst du für `apt install` und für `index.html` den Befehl `sudo`, für
        `nano ~/VM-Ergebnisse/…` aber nicht?
   - b) Der Webserver läuft in der VM, aber du hast die Seite im Firefox auf dem Laptop gesehen.
        Erkläre, wie das geht.
   - c) Was passiert mit deiner Webseite, wenn die VM heruntergefahren wird? Begründe.

---

## Aufgabe 7 – `aufgabe7_rueckblick`

Erstelle mit nano die Datei `~/VM-Ergebnisse/aufgabe7_rueckblick.txt` (erste Zeile: dein Name)
und beantworte die Fragen **ohne** auf den Blättern nachzuschauen. Schreibe ehrlich, was du noch
weisst.

1. Erkläre in je einem kurzen Satz: **Host**, **Gast**, **ISO-Datei**, **Prüfsumme**, **SSH**,
   **sudo**.
2. Bring diese Schritte in die richtige Reihenfolge. Schreibe nur die Buchstaben auf.
   - A) Debian installieren
   - B) Prüfsumme kontrollieren
   - C) Per SSH verbinden
   - D) ISO-Datei herunterladen
   - E) VM erstellen
3. Ein Kollege sagt: «In der VM war ‹Guided – use entire disk› kein Problem. Also kann ich Debian
   genau so auch direkt auf meinem Laptop installieren, ohne vorher etwas zu sichern.»
   Was antwortest du ihm?
4. Was war für dich heute am schwierigsten? Was hat dir am besten gefallen?

---

## ★ Zusatz – `zusatz_schnappschuss` (freiwillig, nur wenn du noch Zeit hast)

Ein **Schnappschuss** speichert den **ganzen Zustand** einer VM, wie ein **Speicherpunkt in einem
Videospiel**. Wenn danach etwas schiefgeht, kehrst du zum Speicherpunkt zurück. Aber Achtung:
Alles, was **nach** dem Speicherpunkt passiert ist, ist dann weg, auch die guten Sachen.

1. Schreibe deinen Namen in die Datei `~/VM-Ergebnisse/zusatz_schnappschuss.txt`.
2. **Schnappschuss erstellen:** Klicke im Fenster der VM auf **Anzeigen** → **Schnappschuss**.
   Klicke unten links auf **+**. Name: **`vor-dem-chaos`**, Schnappschussmodus: **intern**.
   Klicke auf **Fertig** und warte, bis der Schnappschuss in der Liste erscheint.
3. **Chaos machen:** Verbinde dich per SSH mit der VM, lösche deine Webseite mit
   `sudo rm /var/www/html/index.html` und beende die Verbindung. Hänge die Webseite mit `curl` an
   deine Ergebnisdatei an (wie in Aufgabe 6).
4. **Zurück:** Wähle im Fenster der VM `vor-dem-chaos` aus, klicke unten auf das **Dreieck**
   («Ausgewählten Schnappschuss starten») und bestätige mit **Ja**. Hänge die Webseite nochmals
   mit `curl` an. Klicke danach auf **Anzeigen** → **Konsole**.
5. Beantworte unten in der Datei:
   - a) Welche der zwei Webseiten in der Datei ist von **vor** und welche von **nach** dem
        Zurückkehren? Woran erkennst du das?
   - b) Du hättest **nach** dem Schnappschuss eine wichtige Datei in der VM gespeichert und dann
        den Schnappschuss gestartet. Was ist mit der Datei passiert? Warum?

---

## ★ Bonus – `bonus_virsh` (freiwillig, nur wenn du noch Zeit hast)

Alles, was du im Virtual Machine Manager mit der Maus machst, geht auch mit `virsh`.

| Befehl (immer mit `virsh -c qemu:///system` davor) | Was er macht                        |
|-----------------------------------------------------|-------------------------------------|
| `list --all`                                        | zeigt **alle** VMs und ihren Status |
| `shutdown vm-anna`                                  | fährt die VM sauber **herunter**    |
| `start vm-anna`                                     | **startet** die VM                  |

1. Schreibe deinen Namen in die Datei `~/VM-Ergebnisse/bonus_virsh.txt` und hänge das Ergebnis
   von `list --all` an.
2. Fahre deine VM mit `virsh` herunter. Warte ein paar Sekunden und hänge `list --all` nochmals an.
3. Starte die VM wieder mit `virsh`.
4. Beantworte unten in der Datei:
   - a) Was ist der Unterschied zwischen `list` **mit** und **ohne** `--all`? Probiere es aus,
        wenn die VM ausgeschaltet ist.
   - b) Eine Firma hat 200 VMs. Warum ist `virsh` dort praktischer als der Virtual Machine Manager?

---

## Zum Schluss

Kontrolliere mit diesem Befehl, ob alle deine Dateien im Ordner `VM-Ergebnisse` sind:

```
ls ~/VM-Ergebnisse
```

Es sollten mindestens **7 Dateien** sein (Aufgaben 1 bis 7), deren Namen genau so heissen wie
die Aufgaben. **Lass deine VM laufen**, die Betreuungsperson schaut sie vielleicht noch an.

**Gratuliere – du hast deinen eigenen Server gebaut und betrieben! 🖥️🐧**
