#!/usr/bin/env python3
"""Erstellt aufgabenblatt.pdf aus aufgabenblatt.md (A4, jede Aufgabe auf einer neuen Seite).

Braucht das Python-Paket markdown-it-py und Google Chrome oder Chromium:
    python3 -m venv /tmp/pdf-venv && /tmp/pdf-venv/bin/pip install markdown-it-py
    /tmp/pdf-venv/bin/python pdf_erstellen.py
"""
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

try:
    from markdown_it import MarkdownIt
except ImportError:
    sys.exit("markdown-it-py fehlt. Siehe Anleitung oben in pdf_erstellen.py.")

ORDNER = Path(__file__).resolve().parent
QUELLE = ORDNER / "aufgabenblatt.md"
ZIEL = ORDNER / "aufgabenblatt.pdf"

CSS = """
@page { size: A4; margin: 18mm 16mm; }
body { font-family: 'DejaVu Sans', sans-serif; font-size: 9pt; line-height: 1.4; color: #111; }
h1 { font-size: 17pt; border-bottom: 2px solid #111; padding-bottom: 4px; margin: 0 0 10px; }
h2 { font-size: 13pt; border-bottom: 2px solid #111; padding-bottom: 3px; margin: 18px 0 10px; break-before: page; }
h1 + p ~ h2:first-of-type { break-before: auto; }
h3 { font-size: 11pt; margin: 14px 0 6px; break-after: avoid; }
hr { display: none; }
code { font-family: 'DejaVu Sans Mono', monospace; font-size: 8.5pt; background: #ececec; padding: 1px 3px; border-radius: 2px; }
pre { background: #f2f2f2; padding: 8px 10px; border-radius: 3px; break-inside: avoid; }
pre code { background: none; padding: 0; }
table { border-collapse: collapse; width: 100%; margin: 6px 0 10px; break-inside: avoid; font-size: 8.5pt; }
th, td { border: 1px solid #999; padding: 3px 6px; text-align: left; vertical-align: top; }
th { background: #ddd; }
li { margin: 2px 0; }
td code { white-space: nowrap; }
h1 code, h2 code, h3 code { font-size: inherit; }
"""


def main() -> None:
    chrome = next((c for c in ("google-chrome", "chromium", "chromium-browser") if shutil.which(c)), None)
    if chrome is None:
        sys.exit("Google Chrome oder Chromium fehlt.")

    # CommonMark: verschachtelte Listen mit 3 Leerzeichen Einzug werden richtig erkannt.
    body = MarkdownIt("commonmark", {"html": True}).enable("table").render(QUELLE.read_text(encoding="utf-8"))
    html = (f'<!doctype html><html lang="de"><head><meta charset="utf-8"><title>VM-Auftrag</title>'
            f"<style>{CSS}</style></head><body>{body}</body></html>")

    with tempfile.TemporaryDirectory() as tmp:
        seite = Path(tmp) / "aufgabenblatt.html"
        seite.write_text(html, encoding="utf-8")
        subprocess.run([chrome, "--headless=new", "--disable-gpu", "--no-pdf-header-footer",
                        f"--print-to-pdf={ZIEL}", seite.as_uri()],
                       check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    print(f"Erstellt: {ZIEL}")


if __name__ == "__main__":
    main()
