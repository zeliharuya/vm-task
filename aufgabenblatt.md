# VM-Auftrag: Ein Computer im Computer

**Für:** Schnupperlehrlinge, die den Linux-Auftrag gemacht haben  **Zeit:** ca. 3 Stunden
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

| Beispiel        | Benutzername | Name der VM  |
|-----------------|--------------|--------------|
| Anna Muster     | `anna`       | `vm-anna`    |
| Jörg Beispiel   | `joerg`      | `vm-joerg`   |
| Lea-Sophie Test | `leasophie`  | `vm-leasophie` |

Schreib dir deinen Benutzernamen und den Namen deiner VM hier auf:

Benutzername: ______________________   Name der VM: vm-______________________

In allen Befehlen auf diesen Blättern steht als Beispiel `anna` und `vm-anna`.
**Du ersetzt das immer durch deine eigenen Namen.**

### Übersicht

| Nr. | Name der Aufgabe (= Dateiname)  | Thema                                | Zeit   |
|-----|---------------------------------|--------------------------------------|--------|
| 0   | –                               | Vorbereitung                         | 5 Min  |
| 1   | `aufgabe1_virtualisierung`      | Was ist eine virtuelle Maschine?     | 15 Min |
| 2   | `aufgabe2_gastgeber`            | Deinen Laptop kennenlernen           | 10 Min |
| 3   | `aufgabe3_iso`                  | Debian herunterladen und prüfen      | 25 Min |
| 4   | `aufgabe4_vm_erstellen`         | Die virtuelle Maschine erstellen     | 15 Min |
| 5   | `aufgabe5_installation`         | Debian installieren                  | 40 Min |
| 6   | `aufgabe6_erster_start`         | Der erste Start                      | 10 Min |
| 7   | `aufgabe7_ssh`                  | Fernsteuerung mit SSH                | 20 Min |
| 8   | `aufgabe8_webserver`            | Deine eigene Webseite                | 20 Min |
| 9   | `aufgabe9_schnappschuss`        | Zurück in die Vergangenheit          | 15 Min |
| 10  | `aufgabe10_rueckblick`          | Was hast du gelernt?                 | 10 Min |
| ★   | `zusatz_hardware`               | Freiwillig: Mehr Arbeitsspeicher     |   –    |
| ★   | `bonus_virsh`                   | Freiwillig: VMs mit Befehlen steuern |   –    |

Die Aufgaben 0 bis 10 sind Pflicht. Die zwei Aufgaben mit ★ machst du nur, wenn du vorher fertig
bist. Die Aufgaben bauen aufeinander auf: Mach sie **der Reihe nach**.

---

## Aufgabe 0 – Vorbereitung (keine Datei)

### Wiederholung aus dem Linux-Auftrag

| Was                     | Wie                                                              |
|-------------------------|------------------------------------------------------------------|
| Terminal öffnen         | Menü bzw. Suche → **Terminal**                                   |
| Datei bearbeiten        | `nano ~/VM-Ergebnisse/dateiname.txt`                             |
| In nano speichern       | `Ctrl` + `O`, danach Enter                                       |
| nano verlassen          | `Ctrl` + `X`                                                     |
| Ergebnis in Datei, **neu** | `befehl > datei` (löscht, was vorher in der Datei war)        |
| Ergebnis **anhängen**   | `befehl >> datei` (was vorher drin war, bleibt erhalten)         |
| Letzten Befehl holen    | Pfeiltaste `↑`                                                   |
| Namen ergänzen          | Tabulator-Taste `⇥`                                              |
| Einfügen im Terminal    | `Ctrl` + `Shift` + `V`                                           |

| Zeichen | Auf der Schweizer Tastatur                                        |
|---------|-------------------------------------------------------------------|
| `~`     | `AltGr` + `^` (Taste rechts neben `'`), danach die **Leertaste**  |
| `@`     | `AltGr` + `2`                                                     |
| `\|`    | `AltGr` + `7`                                                     |
| `<` `>` | Taste links neben `Y`, für `>` zusätzlich `Shift`                 |

### Dein Ergebnis-Ordner

Kontrolliere, ob der Ordner für deine Ergebnisse da ist:

```
ls ~/VM-Ergebnisse
```

Es darf **keine Fehlermeldung** erscheinen. Der Ordner ist am Anfang leer, also erscheint auch
sonst nichts. Wenn eine Fehlermeldung kommt: Betreuungsperson fragen.

---

## Aufgabe 1 – `aufgabe1_virtualisierung`

**Lies zuerst den Text. Beantworte danach die Fragen.**

### Lesetext: Ein Computer im Computer

Eine **virtuelle Maschine** (kurz **VM**) ist ein Computer, der nicht aus echten Teilen besteht,
sondern nur als **Programm** auf einem echten Computer läuft. Die VM hat einen eigenen Prozessor,
eigenen Arbeitsspeicher, eine eigene Festplatte und eine eigene Netzwerkkarte. Aber all das ist
nur **vorgetäuscht**: In Wirklichkeit leiht sich die VM ein Stück vom echten Computer aus. Ihre
Festplatte ist zum Beispiel nur eine grosse **Datei** auf der Festplatte des echten Computers.

Den echten Computer nennt man **Host** (englisch für Gastgeber). Die VM nennt man **Gast**. Auf
einem Host können gleichzeitig **mehrere** Gäste laufen. Jeder Gast hat sein eigenes
Betriebssystem. So kann auf einem Laptop mit Linux eine VM mit Windows laufen und daneben eine
zweite VM mit einem anderen Linux.

Damit das funktioniert, braucht es einen **Hypervisor**. Das ist die Software, die die Teile des
Hosts an die Gäste verteilt und aufpasst, dass sich die Gäste nicht gegenseitig stören. Man kann
es mit einem **Mehrfamilienhaus** vergleichen: Das **Haus** ist der Host. Die **Wohnungen** sind
die VMs. Jede Wohnung hat eigene Zimmer und eine eigene Türe, und was in einer Wohnung passiert,
merken die Nachbarn nicht. Die **Hausverwaltung** ist der Hypervisor: Sie entscheidet, wie gross
jede Wohnung ist. Mehr Platz, als das Haus hat, kann sie aber nicht verteilen.

Unter Linux heisst der Hypervisor **KVM**. Er ist direkt im **Kern von Linux** eingebaut. Dazu
kommen weitere Programme: **QEMU** spielt die Geräte der VM vor (z. B. Festplatte und
Netzwerkkarte), und mit dem Programm **Virtual Machine Manager** (auf Deutsch «Virtuelle
Maschinenverwaltung») kannst du die VMs mit der Maus erstellen und steuern.

Warum benutzt man VMs? Ein Grund ist **Sicherheit beim Ausprobieren**: Wenn in einer VM etwas
kaputtgeht, ist nur die VM kaputt, der Host läuft normal weiter. Ein zweiter Grund ist **Geld und
Platz**: Statt zehn Server zu kaufen, lässt eine Firma zehn VMs auf einem einzigen starken Server
laufen. Fast alle Angebote aus der **Cloud** (z. B. Webseiten, Online-Speicher) laufen in VMs.
Ein dritter Grund sind **Schnappschüsse**: Man kann den Zustand einer VM speichern und später
dorthin zurückkehren. Das lernst du in Aufgabe 9 kennen.

### Fragen

Öffne die Datei mit:

```
nano ~/VM-Ergebnisse/aufgabe1_virtualisierung.txt
```

Schreibe in die erste Zeile deinen Vor- und Nachnamen. Schreibe vor jede Antwort die Nummer der
Frage (z. B. `1)`).

1. Erkläre **in deinen eigenen Worten** (nicht abschreiben!), was eine virtuelle Maschine ist.
   Schreibe 1–2 Sätze.
2. In diesem Auftrag: Was ist der **Host** und was ist der **Gast**?
3. Richtig oder falsch? Schreibe **R** oder **F** und begründe jede Antwort mit einem Satz.
   - a) Wenn der Host 8 GB Arbeitsspeicher hat, kann man einer VM 16 GB geben.
   - b) Wenn ich in der VM aus Versehen alle Dateien lösche, sind auch die Dateien auf dem Host weg.
   - c) KVM ist ein Teil des Linux-Kerns.
4. Im Text wird ein Vergleich mit einem Mehrfamilienhaus gemacht. Was ist dabei das **Haus**,
   was sind die **Wohnungen** und was ist die **Hausverwaltung**?
5. Wie heisst der **Hypervisor** unter Linux, und wie heisst das **Programm**, mit dem du heute
   die VM mit der Maus erstellst? Antworte mit genau **zwei Namen**.
6. Nenne **drei Gründe** aus dem Text, warum man VMs benutzt.

Speichern (`Ctrl` + `O`, Enter) und nano verlassen (`Ctrl` + `X`).

---

## Aufgabe 2 – `aufgabe2_gastgeber`

### Lesetext: Wie stark ist dein Laptop?

Bevor du eine VM baust, musst du wissen, wie viel dein Host überhaupt hergeben kann. Drei Dinge
sind wichtig:

- **Prozessor (CPU):** Er rechnet. Moderne Prozessoren haben mehrere **Kerne**, die gleichzeitig
  arbeiten können.
- **Arbeitsspeicher (RAM):** Hier liegen die Programme, die gerade laufen. Was die VM an RAM
  bekommt, fehlt dem Host, solange die VM läuft.
- **Festplatte:** Hier wird die Festplatten-Datei der VM gespeichert. Die VMs liegen im Ordner
  `/var/lib/libvirt/images`.

Ausserdem muss der Prozessor **Virtualisierung** unterstützen, sonst ist die VM sehr langsam.
Prozessoren von Intel nennen das **vmx**, Prozessoren von AMD nennen es **svm**.

| Befehl                                  | Was er zeigt                                                   |
|-----------------------------------------|----------------------------------------------------------------|
| `nproc`                                 | die Anzahl **Prozessor-Kerne**                                 |
| `free -h`                               | den **Arbeitsspeicher**. Wichtig ist die Zeile `Speicher:` (bzw. `Mem:`) und die Spalte `gesamt` (bzw. `total`). |
| `df -h /var/lib/libvirt/images`         | wie viel Platz auf der Festplatte dort noch **frei** ist (Spalte `Verf.` bzw. `Avail`). |
| `grep -c -E 'vmx\|svm' /proc/cpuinfo`   | zählt, wie oft `vmx` oder `svm` in der Beschreibung des Prozessors vorkommt. Eine Zahl **grösser als 0** heisst: Der Prozessor kann Virtualisierung. |

Das `-h` bei `free` und `df` heisst «human» (= für Menschen lesbar). Statt riesigen Zahlen in Byte
siehst du dann z. B. `15Gi`. `Gi` steht für Gibibyte, das ist fast das Gleiche wie Gigabyte (GB).

### Aufträge

1. Probiere die vier Befehle aus dem Kasten im Terminal aus und schau dir die Ergebnisse an.
2. Schreibe deinen Namen in die Ergebnisdatei (Ersetze *Vorname Nachname* durch **deinen** Namen):
   ```
   echo "Vorname Nachname" > ~/VM-Ergebnisse/aufgabe2_gastgeber.txt
   ```
3. Hänge nacheinander die Ergebnisse aller **vier** Befehle an diese Datei an.
4. Öffne die Datei mit nano. Kontrolliere, ob dein Name noch in der ersten Zeile steht.
   Beantworte unten diese Fragen:
   - a) Wie viele Prozessor-Kerne hat dein Laptop?
   - b) Wie viel Arbeitsspeicher hat dein Laptop **insgesamt**?
   - c) Wie viel Platz ist im Ordner `/var/lib/libvirt/images` noch frei?
   - d) Kann der Prozessor deines Laptops Virtualisierung? Woran erkennst du das?
   - e) Deine VM bekommt gleich **2 Kerne**, **2 GiB Arbeitsspeicher** und eine **20 GiB**
        grosse Festplatte. Wie viel Arbeitsspeicher bleibt dem Host noch, solange die VM läuft?
        Reicht der freie Platz auf der Festplatte für die VM?

---

## Aufgabe 3 – `aufgabe3_iso`

### Lesetext: ISO-Dateien und Prüfsummen

Früher hat man ein Betriebssystem von einer **CD** oder **DVD** installiert. Heute lädt man
stattdessen eine **ISO-Datei** herunter. Eine ISO-Datei ist eine genaue Kopie einer CD in einer
einzigen Datei. Die VM kann diese Datei benutzen, als wäre eine echte CD eingelegt.

Debian bietet verschiedene ISO-Dateien an. Wir benutzen die kleinste: **netinst** (= «network
install», Installation übers Netzwerk). Sie enthält nur das Nötigste. Alles andere lädt das
Installationsprogramm während der Installation aus dem Internet. Die VM braucht deshalb beim
Installieren eine **Internetverbindung**.

Beim Herunterladen kann etwas schiefgehen: Die Verbindung bricht ab und die Datei ist
unvollständig. Oder jemand Böses hat die Datei unterwegs verändert und ein Schadprogramm eingebaut.
Deshalb veröffentlicht Debian zu jeder ISO-Datei eine **Prüfsumme**. Eine Prüfsumme ist wie ein
**Fingerabdruck** einer Datei: eine lange Zeichenkette, die aus dem ganzen Inhalt der Datei
berechnet wird. Ändert sich in der Datei auch nur **ein einziges Zeichen**, kommt ein **komplett
anderer** Fingerabdruck heraus. Wir benutzen das Verfahren **SHA-256**.

| Befehl                         | Was er macht                                                          |
|--------------------------------|-----------------------------------------------------------------------|
| `sha256sum datei`              | berechnet die Prüfsumme der Datei.                                    |
| `sha256sum -c SHA256SUMS`      | liest die Liste `SHA256SUMS` mit den richtigen Prüfsummen, berechnet die Prüfsumme jeder Datei aus der Liste und vergleicht («c» für «check» = prüfen). Stimmt sie, steht `OK` hinter dem Dateinamen. Stimmt sie **nicht**, steht dort `FEHLSCHLAG` (bzw. `FAILED`). |
| `ls -lh datei`                 | zeigt Informationen über die Datei an, unter anderem ihre **Grösse**. |

### Aufträge

**Teil A: Herunterladen starten.** Der Download dauert einige Minuten. Starte ihn deshalb zuerst
und mach während des Wartens Teil B.

1. Öffne den **Firefox** und tippe diese Adresse ein (genau abschreiben):
   ```
   cdimage.debian.org/debian-cd/current/amd64/iso-cd/
   ```
2. Weiter unten auf der Seite siehst du eine Liste mit Dateien. Darin gibt es **drei**
   ISO-Dateien, deren Namen auf `-amd64-netinst.iso` enden. Wir brauchen die Datei, bei der
   direkt nach `debian-` eine **Zahl** kommt (die Versionsnummer), also **nicht** `debian-edu-…`
   und **nicht** `debian-mac-…`. Klicke darauf, um sie herunterzuladen. Firefox speichert sie im
   Ordner `Downloads`.

**Teil B: Prüfsummen üben.** In deinem persönlichen Ordner gibt es den Ordner
`vm-auftrag/pruefsummen`. Darin liegen drei kleine Übungsdateien und eine Liste mit ihren
richtigen Prüfsummen. Eine der drei Dateien wurde unterwegs beschädigt.

3. Schreibe deinen Namen in die Datei `~/VM-Ergebnisse/aufgabe3_iso.txt` (wie in Aufgabe 2).
4. Wechsle in den Ordner `~/vm-auftrag/pruefsummen` und schau dir die Datei `SHA256SUMS` mit
   `cat` an.
5. Berechne mit `sha256sum` die Prüfsumme von `paket1.iso` und vergleiche sie von Auge mit der
   Liste. (Es reicht, die ersten und letzten paar Zeichen zu vergleichen.)
6. Das Vergleichen von Auge ist mühsam. Lass jetzt den Computer alle drei Dateien prüfen und hänge
   das Ergebnis an deine Ergebnisdatei an:
   ```
   sha256sum -c SHA256SUMS >> ~/VM-Ergebnisse/aufgabe3_iso.txt
   ```
   Die Warnung, die dabei im Terminal erscheint, gehört so. Sie landet nicht in der Datei.
7. Teste, wie stark sich die Prüfsumme bei einer kleinen Änderung verändert. Tippe diese zwei
   Befehle (einmal mit grossem **H**, einmal mit kleinem **h**) und vergleiche die Ergebnisse:
   ```
   echo Hallo | sha256sum
   echo hallo | sha256sum
   ```

**Teil C: Die echte ISO-Datei prüfen.** Warte, bis der Download im Firefox fertig ist.

8. Wechsle in den Ordner `~/Downloads` und lade dort die Liste mit den richtigen Prüfsummen von
   Debian herunter. `wget` lädt die Datei, deren Adresse du angibst, in den aktuellen Ordner:
   ```
   wget https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/SHA256SUMS
   ```
9. Hänge Informationen über die ISO-Datei an deine Ergebnisdatei an. Der Stern `*` steht für
   «beliebige Zeichen», so musst du die Versionsnummer nicht abtippen:
   ```
   ls -lh debian-*-amd64-netinst.iso >> ~/VM-Ergebnisse/aufgabe3_iso.txt
   ```
10. Prüfe jetzt die ISO-Datei und hänge das Ergebnis an. Die Liste von Debian enthält die
    Prüfsummen aller **drei** ISO-Dateien, du hast aber nur **eine** heruntergeladen. Mit
    `--ignore-missing` («fehlende ignorieren») meckert `sha256sum` nicht über die zwei Dateien,
    die du nicht hast:
    ```
    sha256sum -c --ignore-missing SHA256SUMS >> ~/VM-Ergebnisse/aufgabe3_iso.txt
    ```
    Das Berechnen dauert ein paar Sekunden. Kontrolliere mit `cat`, ob hinter dem Namen der
    ISO-Datei `OK` steht. Wenn nicht: Betreuungsperson fragen.
11. Öffne die Ergebnisdatei mit nano und beantworte unten:
    - a) Welche der drei Übungsdateien war beschädigt?
    - b) Was ist dir bei `Hallo` und `hallo` in Auftrag 7 aufgefallen? Was sagt dir das über
         Prüfsummen?
    - c) Wie gross ist die ISO-Datei?
    - d) Warum braucht die VM eine Internetverbindung, wenn wir sie mit der netinst-ISO
         installieren?
    - e) Was hättest du gemacht, wenn bei der ISO-Datei `FEHLSCHLAG` gestanden hätte? Warum?

---

## Aufgabe 4 – `aufgabe4_vm_erstellen`

### Lesetext: Die VM einrichten

Jetzt baust du die VM. Dafür benutzt du den **Virtual Machine Manager**. Du stellst ein, wie viel
von deinem Laptop die VM bekommt. Dein Laptop teilt sich dabei ein Netzwerk mit der VM: Die VM
bekommt eine eigene Adresse in einem **privaten Netzwerk**, das nur auf deinem Laptop existiert.
Ins Internet kommt sie über deinen Laptop, so wie dein Handy zu Hause über den WLAN-Router ins
Internet kommt. Diese Art von Netzwerk heisst **NAT**.

Diese Einstellungen brauchst du:

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
   «Virtual Machine Manager»). Im Fenster siehst du die Zeile **QEMU/KVM**. Das ist die
   Verbindung zum Hypervisor auf deinem Laptop.
2. Klicke oben links auf das erste Symbol (Bildschirm mit einem Stern, «Neue virtuelle Maschine
   erstellen»). Ein Assistent führt dich in **5 Schritten** durch die Einrichtung:
   - **Schritt 1 von 5:** Wähle **Lokales Installationsmedium (ISO-Abbild oder CDROM)**.
     Klicke auf **Weiter**.
   - **Schritt 2 von 5:** Klicke auf **Durchsuchen …**. Es öffnet sich ein neues Fenster. Klicke
     darin **unten** auf **Browse Local**, gehe in den Ordner `Downloads`, wähle die ISO-Datei
     und klicke auf **Öffnen**. Das Häkchen bei **Automatische Erkennung …** bleibt gesetzt.
     Darunter muss **Debian 13** stehen. Klicke auf **Weiter**.
     Wenn eine Meldung kommt, dass der Emulator **keine Suchberechtigungen** für den Pfad hat:
     Klicke auf **Ja**. (Der Hypervisor darf sonst die ISO-Datei in deinem persönlichen Ordner
     nicht lesen.)
   - **Schritt 3 von 5:** Trage bei **Speicher** und **CPUs** die Werte aus der Tabelle ein.
     Klicke auf **Weiter**.
   - **Schritt 4 von 5:** Lass die Häkchen gesetzt und trage die Grösse der Festplatte aus der
     Tabelle ein. Klicke auf **Weiter**.
   - **Schritt 5 von 5:** Lösche den vorgeschlagenen Namen und trage **deinen** VM-Namen ein.
     Klicke auf **Netzwerk Auswahl** und kontrolliere, ob dort das NAT-Netzwerk aus der Tabelle steht. Das
     Häkchen bei **Konfiguration bearbeiten vor der Installation** setzt du **nicht**.
     Kontrolliere alle Angaben noch einmal mit der Tabelle und klicke dann auf **Fertig**.
3. Ein neues Fenster öffnet sich. Das ist der **Bildschirm deiner VM**. Sie startet von der
   ISO-Datei, und du siehst das Startmenü von Debian. **Klicke noch nichts an!** Mach zuerst die
   Aufträge 4 bis 6.
4. Schreibe deinen Namen in die Datei `~/VM-Ergebnisse/aufgabe4_vm_erstellen.txt`.
5. Mit dem Befehl `virsh` kannst du VMs auch im Terminal anschauen. Hänge die Informationen über
   deine VM an deine Ergebnisdatei an (mit **deinem** VM-Namen am Schluss):
   ```
   virsh -c qemu:///system dominfo vm-anna >> ~/VM-Ergebnisse/aufgabe4_vm_erstellen.txt
   ```
   `qemu:///system` sagt `virsh`, dass es sich mit dem Hypervisor auf deinem Laptop verbinden soll.
   `dominfo` heisst «domain info». **Domain** ist bei `virsh` ein anderes Wort für VM.
   Wenn eine Fehlermeldung kommt: Schau genau, ob du den Namen richtig geschrieben hast.
6. Öffne die Datei mit nano und beantworte unten:
   - a) Wie viele CPUs hat deine VM laut `dominfo`?
   - b) Bei `Max Speicher` (bzw. `Max memory`) steht der Arbeitsspeicher in **KiB**. Rechne ihn
        in MiB um (1 MiB = 1024 KiB). Stimmt er mit der Tabelle überein?
   - c) Was steht bei `Status` (bzw. `State`)?
   - d) Die VM startet von der ISO-Datei und nicht von ihrer Festplatte. Warum?

---

## Aufgabe 5 – `aufgabe5_installation`

### Lesetext: Was bei der Installation passiert

Das Installationsprogramm von Debian stellt dir viele Fragen. Ein paar Begriffe musst du dafür
kennen:

**Rechnername:** Jeder Computer in einem Netzwerk hat einen Namen, damit man ihn erkennt. Deine
VM bekommt den gleichen Namen wie in Aufgabe 4, also z. B. `vm-anna`.

**root und sudo:** Unter Linux gibt es einen besonderen Benutzer mit dem Namen **root**. root ist
der **Administrator** und darf alles, auch das ganze System kaputtmachen. Darum arbeitet man nicht
als root, sondern als normaler Benutzer. Wenn man etwas Wichtiges ändern muss, z. B. ein Programm
installieren, setzt man **`sudo`** vor den Befehl. Dann wird nur **dieser eine Befehl** mit den
Rechten des Administrators ausgeführt, und Linux fragt vorher nach **deinem** Passwort.
Im Installationsprogramm gilt: Wenn du für root **kein** Passwort eingibst, ist root gesperrt und
**dein** Benutzer darf stattdessen `sudo` benutzen. Genau das wollen wir.

**Partitionieren:** Bevor ein Betriebssystem auf eine Festplatte kommt, muss die Festplatte
eingeteilt werden, so wie man einen leeren Schrank mit Fächern einteilt. Diese Fächer heissen
**Partitionen**. Dabei wird **alles gelöscht**, was vorher auf der Festplatte war. Achtung: Das
Installationsprogramm sieht nur die Festplatte, die es vor sich hat. Bei einer Installation auf
einem echten Computer wäre das die echte Festplatte mit allen Fotos und Dokumenten.

**Server ohne Desktop:** Debian bietet an, eine **Desktop-Umgebung** zu installieren, also
Fenster, Maus und Menüs. Wir installieren unsere VM wie einen echten **Server** **ohne**
Desktop-Umgebung. Ein Server steht meistens in einem Rechenzentrum, und niemand sitzt davor.
Man steuert ihn aus der Ferne, mit Text-Befehlen. Ohne Desktop braucht die VM ausserdem
**viel weniger Arbeitsspeicher und Festplatte**, und die Installation geht schneller. Stattdessen
installieren wir einen **SSH-Server**. Damit kannst du die VM in Aufgabe 7 von deinem Laptop aus
fernsteuern.

### Aufträge

Klicke in das Fenster deiner VM. Arbeite die Tabelle **Zeile für Zeile** ab. Mit **Weiter** (unten
rechts) kommst du zur nächsten Frage. Wenn du dich verklickt hast, kommst du mit **Zurück** oft
eine Frage zurück. Fragen, die **nicht** in der Tabelle stehen, beantwortest du mit dem, was schon
ausgewählt ist.

> **Maus gefangen?** Wenn die Maus im Fenster der VM festhängt, drückst du `Ctrl` + `Alt`
> (beide links). Dann ist die Maus wieder frei.

| Nr. | Frage / Bildschirm                                    | Deine Antwort                                         |
|-----|-------------------------------------------------------|-------------------------------------------------------|
| 1   | Startmenü (Debian GNU/Linux installer menu)           | **Graphical install**, mit Enter starten              |
| 2   | Select a language                                     | **German – Deutsch**                                  |
| 3   | Auswählen des Standorts                               | **Schweiz**                                           |
| 4   | Tastatur konfigurieren                                | **Schweizerdeutsch**                                  |
| 5   | Rechnername                                           | dein VM-Name, z. B. **`vm-anna`**                     |
| 6   | Domain-Name                                           | **leer lassen**                                       |
| 7   | Root-Passwort (und Bestätigung)                       | **beide Felder leer lassen!** (siehe Lesetext)        |
| 8   | Vollständiger Name des neuen Benutzers                | dein Vor- und Nachname                                |
| 9   | Benutzername für Ihr Konto                            | dein Benutzername, z. B. **`anna`** (kontrollieren!)  |
| 10  | Passwort für den neuen Benutzer (und Bestätigung)     | ein Passwort, das du dir **merken** kannst            |
| 11  | Partitionierungsmethode                               | **Geführt – vollständige Festplatte verwenden**       |
| 12  | Zu partitionierende Festplatte                        | die einzige Festplatte (**vda**, ca. 21 GB)           |
| 13  | Partitionierungsschema                                | **Alle Dateien auf eine Partition** …                 |
| 14  | Übersicht der Partitionen                             | **Partitionierung beenden und Änderungen übernehmen** |
| 15  | Änderungen auf die Festplatten schreiben?             | **Ja** – Achtung, vorausgewählt ist **Nein**!         |
| –   | *Das Grundsystem wird installiert (einige Minuten)*   | *warten, Fragen aus Auftrag 1 bearbeiten*             |
| 16  | Weitere Installationsmedien prüfen?                   | **Nein**                                              |
| 17  | Land und Spiegelserver für das Debian-Archiv          | **Schweiz**, danach **deb.debian.org**                |
| 18  | HTTP-Proxy                                            | **leer lassen**                                       |
| 19  | Paketverwendungserfassung (popularity-contest)        | **Nein**                                              |
| 20  | Softwareauswahl                                       | siehe Kasten unten                                    |
| –   | *Software wird installiert (einige Minuten)*          | *warten, Fragen aus Auftrag 1 bearbeiten*             |
| 21  | GRUB-Bootloader auf dem primären Laufwerk installieren? | **Ja**, danach **/dev/vda** auswählen               |
| 22  | Installation abgeschlossen                            | **Weiter**. Die VM startet neu.                       |

> **Softwareauswahl (Nr. 20) – genau lesen!**
> Es soll **nur** bei diesen zwei Einträgen ein Häkchen sein:
> **SSH server** und **Standard-Systemwerkzeuge**.
> Entferne das Häkchen bei der **Desktop-Umgebung** und bei **GNOME**.
> Alle anderen Einträge bleiben ohne Häkchen.

Nach dem Neustart erscheint ein schwarzer Bildschirm mit weisser Schrift und der Zeile
`vm-anna login:`. Dann ist die Installation fertig. Melde dich **noch nicht** an, das machst du in
Aufgabe 6.

**Auftrag 1 (während des Wartens):** Erstelle die Datei `~/VM-Ergebnisse/aufgabe5_installation.txt`
(erste Zeile: dein Name) und beantworte:

- a) Welchen **Rechnernamen** und welchen **Benutzernamen** hast du gewählt? (**Kein** Passwort
     hinschreiben!)
- b) Das Installationsprogramm warnt, dass alle Daten auf der Festplatte gelöscht werden. Warum ist
     das für deinen Laptop **ungefährlich**?
- c) Warum hast du das Root-Passwort **leer** gelassen? Was darf dein Benutzer deshalb?
- d) Was ist der Unterschied zwischen «als root arbeiten» und «`sudo` benutzen»? Warum ist `sudo`
     sicherer?
- e) Nenne **zwei Gründe** aus dem Text, warum wir **keine** Desktop-Umgebung installieren.

---

## Aufgabe 6 – `aufgabe6_erster_start`

### Lesetext: Die IP-Adresse

Jedes Gerät in einem Netzwerk hat eine **IP-Adresse**. Sie besteht aus vier Zahlen mit Punkten
dazwischen, z. B. `192.168.122.57`. Über diese Adresse finden sich die Geräte gegenseitig, so wie
ein Brief über die Postadresse ankommt. Deine VM hat ihre IP-Adresse beim Starten automatisch vom
privaten NAT-Netzwerk auf deinem Laptop bekommen. Du brauchst sie in den nächsten Aufgaben.

### Aufträge

1. Klicke in das Fenster der VM. Tippe bei `login:` deinen **Benutzernamen** und drücke Enter.
   Tippe danach dein Passwort und drücke Enter. **Beim Passwort erscheinen keine Zeichen, auch
   keine Sternchen.** Das ist unter Linux normal. Tippe einfach weiter.
2. Schau dir die Eingabeaufforderung an. Sie sieht etwa so aus: `anna@vm-anna:~$`
3. Tippe in der VM diese zwei Befehle:
   ```
   hostname -I
   cat /etc/debian_version
   ```
   `hostname -I` zeigt die IP-Adresse(n) der VM. `/etc/debian_version` enthält die genaue
   Versionsnummer von Debian.
4. Im Fenster der VM kannst du **nichts kopieren**. Erstelle deshalb auf deinem **Laptop** mit nano
   die Datei `~/VM-Ergebnisse/aufgabe6_erster_start.txt` (erste Zeile: dein Name) und schreibe die
   Antworten von Hand ab:
   - a) Die IP-Adresse deiner VM (die erste Adresse, die mit `192.168.` beginnt).
        **Schreibe sie dir auch hier auf:** ____ . ____ . ____ . ____
   - b) Die Debian-Version aus `/etc/debian_version`.
   - c) Vergleiche die Eingabeaufforderung im **Terminal deines Laptops** mit der in der **VM**.
        Was ist gleich, was ist anders? Woran erkennst du, auf welchem Computer du gerade tippst?
   - d) Warum gibt es in der VM keine Maus und keine Fenster?

> Lass die VM ab jetzt einfach laufen. Du kannst ihr Fenster verkleinern, aber **schliess** die VM
> nicht und fahr sie nicht herunter.

---

## Aufgabe 7 – `aufgabe7_ssh`

### Lesetext: Fernsteuerung mit SSH

Im Linux-Auftrag hast du gelesen, dass Server oft keinen Bildschirm haben und man sie aus der
Ferne mit Text-Befehlen steuert. Das Werkzeug dafür heisst **SSH** («Secure Shell»). Mit SSH
öffnest du im Terminal deines Laptops ein Terminal **auf einem anderen Computer**. Alles, was
dabei durchs Netzwerk geht, ist **verschlüsselt**. Niemand kann mitlesen, auch nicht dein Passwort.

```
ssh benutzer@adresse
```

- `benutzer` ist dein Benutzername **in der VM**.
- Das Zeichen `@` heisst «at» (= «bei»). `anna@192.168.122.57` heisst also: «Benutzerin `anna`
  auf dem Computer mit der Adresse `192.168.122.57`».
- Beim **allerersten** Verbinden fragt SSH: `Are you sure you want to continue connecting
  (yes/no/[fingerprint])?` Damit fragt SSH, ob du diesem Computer vertraust. Hier musst du das
  ganze Wort **`yes`** ausschreiben. Nur `y` reicht nicht.
- Danach fragt SSH nach dem Passwort. Wie in der VM erscheinen beim Tippen keine Zeichen.
- Mit **`exit`** beendest du die Verbindung und bist wieder auf deinem Laptop.

**Wo bin ich?** Ab jetzt hast du zwei Computer, die gleich aussehen. Schau deshalb **vor jedem
Befehl** auf die Eingabeaufforderung. Steht dort `vm-anna`, tippst du in der VM.

**Ein einzelner Befehl:** Du kannst einen Befehl auch direkt hinter die Adresse schreiben. Dann
führt SSH nur diesen einen Befehl in der VM aus und kommt sofort zurück:

```
ssh anna@192.168.122.57 hostname
```

Das Ergebnis erscheint im Terminal **deines Laptops**. Das heisst: Mit `>>` kannst du es in eine
Datei **auf deinem Laptop** schreiben.

### Aufträge

1. Schreibe deinen Namen in die Datei `~/VM-Ergebnisse/aufgabe7_ssh.txt`.
2. Verbinde dich im Terminal deines Laptops per SSH mit deiner VM. Benutze **deinen**
   Benutzernamen und die IP-Adresse aus Aufgabe 6.
3. Schau dir die Eingabeaufforderung an. Tippe `whoami` und `hostname` und beende danach die
   Verbindung mit `exit`.
4. Hänge jetzt nacheinander die Ergebnisse dieser **fünf** Befehle **aus der VM** an deine
   Ergebnisdatei **auf dem Laptop** an. Benutze dafür SSH mit einem einzelnen Befehl (siehe
   Lesetext). Jedes Mal wird nach dem Passwort gefragt.
   **Tipp:** Mit `↑` holst du den letzten Befehl zurück und musst nur noch den Befehl in der
   Mitte ändern.
   ```
   hostname
   nproc
   free -h
   lsblk
   groups
   ```
   `lsblk` zeigt die Festplatten («list block devices»), `groups` zeigt, in welchen **Gruppen**
   dein Benutzer ist. Eine Gruppe ist eine Liste von Benutzern, die gleiche Rechte haben.
5. Kontrolliere mit `cat`, ob alles in der Datei steht. Die Ergebnisse von `nproc` und `free -h`
   müssen **anders** aussehen als in Aufgabe 2. Wenn nicht, hast du sie auf dem Laptop statt in
   der VM ausgeführt.
6. Öffne die Datei mit nano und beantworte unten:
   - a) Vergleiche die Anzahl **Kerne** und den **Arbeitsspeicher** der VM mit deinem Laptop aus
        Aufgabe 2. Warum sind die Zahlen in der VM kleiner?
   - b) `lsblk` zeigt eine Festplatte `vda` mit ca. 20 GiB. Wo ist diese Festplatte in Wirklichkeit
        gespeichert? (Die Antwort steht in Aufgabe 1 und 2.)
   - c) Dein Benutzer ist in der Gruppe `sudo`. Was darf er deshalb? Warum ist er in dieser Gruppe?
   - d) Warum hast du beim Verbinden `anna@` (bzw. deinen Namen) vor die Adresse geschrieben?
        Was meinst du, was passiert ohne?

---

## Aufgabe 8 – `aufgabe8_webserver`

### Lesetext: Programme installieren und Webseiten anbieten

Unter Linux installiert man Programme meistens nicht von Webseiten, sondern mit einer
**Paketverwaltung**. Sie funktioniert ähnlich wie ein App Store auf dem Handy: Alle Programme
(**Pakete**) liegen geprüft auf den Servern von Debian. Unter Debian heisst die Paketverwaltung
**apt**.

| Befehl                    | Was er macht                                                       |
|---------------------------|--------------------------------------------------------------------|
| `sudo apt update`         | lädt die **aktuelle Liste** aller Pakete herunter. Es wird noch nichts installiert. |
| `sudo apt install paket`  | lädt das Paket herunter und **installiert** es.                    |

Programme installieren verändert das System. Darum braucht es `sudo`.

Ein **Webserver** ist ein Programm, das Webseiten an Browser ausliefert. Wenn du im Browser eine
Adresse eintippst, fragt der Browser beim Webserver nach der Seite, und der Webserver schickt sie
zurück. Wir installieren den Webserver **nginx** (ausgesprochen «engine-x»). Er liefert die Dateien
aus dem Ordner **`/var/www/html`** aus. Die Startseite heisst `index.html`. Dieser Ordner gehört
dem System, darum braucht es auch zum Bearbeiten `sudo`.

Webseiten werden in **HTML** geschrieben. Der Text steht zwischen **Tags** in spitzen Klammern:
`<h1>…</h1>` ist eine grosse Überschrift, `<p>…</p>` ein normaler Absatz.

Mit dem Befehl **`curl`** kannst du eine Webseite im Terminal abholen statt im Browser. Du siehst
dann den HTML-Text der Seite.

### Aufträge

1. Verbinde dich per SSH mit deiner VM (nicht mit einem einzelnen Befehl, sondern so, dass du in
   der VM bleibst).
2. Lade in der VM die aktuelle Paketliste herunter und installiere danach das Paket `nginx`. Wenn
   `sudo` nach einem Passwort fragt, ist das **dein** Passwort. Wenn `apt` fragt, ob du fortfahren
   möchtest, drückst du `J` (bzw. `Y`) und Enter.
3. Öffne auf deinem Laptop den Firefox und tippe als Adresse `http://` und dahinter die
   IP-Adresse deiner VM ein, z. B. `http://192.168.122.57`. Es sollte **Welcome to nginx!**
   erscheinen.
4. Erstelle jetzt in der VM deine eigene Startseite:
   ```
   sudo nano /var/www/html/index.html
   ```
   Tippe diesen Text ab. Ersetze die Teile in Grossbuchstaben durch deine eigenen Angaben:
   ```
   <!DOCTYPE html>
   <html>
   <head><meta charset="utf-8"><title>Meine VM</title></head>
   <body>
   <h1>Willkommen auf VM-NAME</h1>
   <p>Diese Seite hat VORNAME NACHNAME gemacht.</p>
   <p>Mein Lieblingshobby: HOBBY</p>
   </body>
   </html>
   ```
   Speichern und nano verlassen.
5. Lade die Seite im Firefox neu (Taste `F5`). Jetzt erscheint deine Seite.
6. Beende die SSH-Verbindung. Schreibe auf dem **Laptop** deinen Namen in die Datei
   `~/VM-Ergebnisse/aufgabe8_webserver.txt` und hänge danach die Webseite mit `curl` an. Das `-s`
   heisst «silent» (= still) und unterdrückt Statusmeldungen:
   ```
   curl -s http://192.168.122.57 >> ~/VM-Ergebnisse/aufgabe8_webserver.txt
   ```
7. Öffne die Datei mit nano und beantworte unten:
   - a) Warum brauchst du für `apt install` und für das Bearbeiten von `index.html` den Befehl
        `sudo`, für `nano ~/VM-Ergebnisse/…` aber nicht?
   - b) Was ist der Unterschied zwischen `apt update` und `apt install`?
   - c) Der Webserver läuft in der VM, aber du hast die Seite im Firefox auf deinem Laptop
        gesehen. Erkläre, wie das geht.
   - d) Was passiert mit deiner Webseite, wenn die VM heruntergefahren wird? Begründe.

---

## Aufgabe 9 – `aufgabe9_schnappschuss`

### Lesetext: Schnappschüsse

Ein **Schnappschuss** speichert den **ganzen Zustand** einer VM in diesem Moment: alle Dateien auf
ihrer Festplatte und sogar die Programme, die gerade laufen. Später kannst du zu diesem Zustand
**zurückkehren**. Es ist wie ein **Speicherpunkt in einem Videospiel**: Wenn danach etwas schiefgeht,
lädst du einfach den Speicherpunkt. Aber Achtung: Alles, was **nach** dem Speicherpunkt passiert
ist, ist dann weg, auch die guten Sachen.

Fachleute machen zum Beispiel vor einem grossen Update einen Schnappschuss. Geht beim Update
etwas kaputt, ist der Server in einer Minute wieder so wie vorher.

### Aufträge

1. Schreibe deinen Namen in die Datei `~/VM-Ergebnisse/aufgabe9_schnappschuss.txt`.
2. **Schnappschuss erstellen:** Geh zum Fenster deiner VM. Klicke oben im Menü auf **Anzeigen** →
   **Schnappschuss**. Klicke unten links auf **+** («Neuen Schnappschuss erstellen»). Trage als
   Name **`vor-dem-chaos`** ein und wähle beim **Schnappschussmodus** die Einstellung **intern**.
   Klicke auf **Fertig** und warte, bis der Schnappschuss in der Liste links erscheint.
3. **Chaos machen:** Verbinde dich per SSH mit der VM und **lösche** deine Webseite:
   ```
   sudo rm /var/www/html/index.html
   ```
   Beende die SSH-Verbindung. Lade die Seite im Firefox neu. Deine Seite ist weg, nginx zeigt
   wieder seine eigene Startseite.
4. Hänge den jetzigen Zustand mit `curl` an deine Ergebnisdatei an (wie in Aufgabe 8, Auftrag 6).
5. **Zurück in die Vergangenheit:** Wähle im Fenster der VM in der Liste der Schnappschüsse
   `vor-dem-chaos` aus. Klicke unten auf das **Dreieck** («Ausgewählten Schnappschuss starten»)
   und bestätige die Frage mit **Ja**.
6. Lade die Seite im Firefox neu. Hänge den Zustand nochmals mit `curl` an deine Ergebnisdatei an.
7. Klicke im Fenster der VM auf **Anzeigen** → **Konsole**, damit du wieder den Bildschirm der VM
   siehst.
8. Öffne die Ergebnisdatei mit nano. Darin stehen jetzt zwei Webseiten. Beantworte unten:
   - a) Welche der zwei Webseiten in der Datei stammt von **vor** und welche von **nach** dem
        Zurückkehren zum Schnappschuss? Woran erkennst du das?
   - b) Erkläre in deinen eigenen Worten, was ein Schnappschuss ist.
   - c) Stell dir vor, du hättest **nach** dem Schnappschuss eine wichtige Datei in der VM
        gespeichert und danach den Schnappschuss gestartet. Was ist mit der Datei passiert? Warum?

---

## Aufgabe 10 – `aufgabe10_rueckblick`

Erstelle mit nano die Datei `~/VM-Ergebnisse/aufgabe10_rueckblick.txt` (erste Zeile: dein Name)
und beantworte die Fragen **ohne** auf den Blättern nachzuschauen. Es ist nicht schlimm, wenn du
nicht alles weisst. Schreibe ehrlich, was du noch weisst.

1. Erkläre in je einem kurzen Satz: **Host**, **Gast**, **Hypervisor**, **ISO-Datei**,
   **Prüfsumme**, **SSH**, **sudo**, **Schnappschuss**.
2. Bring diese Schritte in die richtige Reihenfolge. Schreibe nur die Buchstaben auf.
   - A) Debian installieren
   - B) Prüfsumme kontrollieren
   - C) Per SSH verbinden
   - D) ISO-Datei herunterladen
   - E) VM erstellen
3. Ein Kollege sagt: «In der VM war ‹vollständige Festplatte verwenden› kein Problem. Also kann ich
   Debian genau so auch direkt auf meinem Laptop installieren, ohne vorher etwas zu sichern.»
   Was antwortest du ihm? Begründe.
4. Was war für dich heute am schwierigsten? Was hat dir am besten gefallen?

---

## ★ Zusatz – `zusatz_hardware` (freiwillig, nur wenn du noch Zeit hast)

Eine VM kann man nachträglich «aufrüsten», ohne einen Schraubenzieher anzufassen. Wie bei einem
echten Computer muss sie dafür aber **ausgeschaltet** sein.

1. Schreibe deinen Namen in die Datei `~/VM-Ergebnisse/zusatz_hardware.txt`.
2. Verbinde dich per SSH mit der VM und fahre sie herunter: `sudo poweroff`
   (die SSH-Verbindung bricht dabei ab, das ist normal).
3. Klicke im Fenster der VM auf **Anzeigen** → **Details**. Klicke links auf **Speicher**. Setze
   **beide** Werte (aktuelle und maximale Zuweisung) auf **3072** MiB und klicke auf
   **Übernehmen**.
4. Klicke auf **Anzeigen** → **Konsole** und starte die VM mit dem **Dreieck** in der Leiste oben
   («Starten»). Warte, bis `login:` erscheint.
5. Hänge das Ergebnis von `free -h` **aus der VM** an deine Ergebnisdatei an (per SSH, wie in
   Aufgabe 7). Hinweis: Wenn SSH keine Verbindung bekommt, hat die VM eventuell eine neue
   IP-Adresse bekommen. Schau in der VM mit `hostname -I` nach.
6. Beantworte unten in der Datei:
   - a) Wie viel Arbeitsspeicher zeigt `free -h` jetzt? Wie viel war es in Aufgabe 7?
   - b) Wie viel Arbeitsspeicher könntest du der VM **höchstens** geben, und warum wäre das
        keine gute Idee? (Denk an Aufgabe 2.)

---

## ★ Bonus – `bonus_virsh` (freiwillig, nur wenn du noch Zeit hast)

Alles, was du im Virtual Machine Manager mit der Maus machst, geht auch mit dem Befehl `virsh`.
Fachleute benutzen das, wenn sie viele VMs auf einmal steuern oder nur per SSH auf den Host
zugreifen können.

| Befehl (immer mit `virsh -c qemu:///system` davor) | Was er macht                       |
|-----------------------------------------------------|------------------------------------|
| `list --all`                                        | zeigt **alle** VMs und ihren Status |
| `shutdown vm-anna`                                  | fährt die VM sauber **herunter**    |
| `start vm-anna`                                     | **startet** die VM                  |
| `snapshot-list vm-anna`                             | zeigt die **Schnappschüsse** der VM |

1. Schreibe deinen Namen in die Datei `~/VM-Ergebnisse/bonus_virsh.txt` und hänge die Ergebnisse
   von `list --all` und `snapshot-list` an.
2. Fahre deine VM mit `virsh` herunter. Warte ein paar Sekunden und hänge das Ergebnis von
   `list --all` nochmals an.
3. Starte die VM wieder mit `virsh`.
4. Beantworte unten in der Datei:
   - a) Was ist der Unterschied zwischen `virsh -c qemu:///system list` **mit** und **ohne**
        `--all`? Probiere es aus, wenn die VM ausgeschaltet ist.
   - b) Eine Firma hat 200 VMs. Warum ist `virsh` dort praktischer als der Virtual Machine Manager?

---

## Zum Schluss

Kontrolliere mit diesem Befehl, ob alle deine Dateien im Ordner `VM-Ergebnisse` sind:

```
ls ~/VM-Ergebnisse
```

Es sollten mindestens **10 Dateien** sein (Aufgaben 1 bis 10), deren Namen genau so heissen wie
die Aufgaben. **Lass deine VM laufen**, die Betreuungsperson schaut sie vielleicht noch an.

**Gratuliere – du hast deinen eigenen Server gebaut und betrieben! 🖥️🐧**
