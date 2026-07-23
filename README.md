# Workshop: Agentische Entwicklung

Schulungsmaterial, um einem Dev-Team (erfahren, **neu bei Agenten**) agentische Entwicklung
und den Aufbau eines Multi-Agent-Dev-Systems zu erklären — am Beispiel unseres Setups.

Zwei Deliverables aus **einer Quelle**: ein **30-Min-Impulsvortrag** ist die markierte
Teilmenge des **2-Stunden-Workshops**.

## Dateien

| Datei | Zweck |
|---|---|
| `workshop-deck.html` | Das präsentierbare Deck. Im Browser öffnen, mit Pfeiltasten navigieren. Enthält beide Modi (Workshop / Impuls) über einen Umschalter. |
| `workshop-content.md` | Content-Gerüst mit **Sprecher-Notizen**, Diagramm-Briefs und `[IMPULS]`-Markern. Die editierbare Quelle — hier Inhalte ändern, dann ins Deck übertragen. |
| `hands-on-kit/` | Schritt-für-Schritt-Kit für die Hands-on-Phase: fertiges Mini-System aus 5 Zutaten im `starter/`-Repo + `README.md` mit vier Übungen. |

## Deck bedienen

Im Browser öffnen (Doppelklick auf `workshop-deck.html` — keine Server, keine Abhängigkeiten).

| Taste | Aktion |
|---|---|
| `→` / `Leertaste` / `Bild ab` | Nächste Folie |
| `←` / `Bild auf` | Vorige Folie |
| `Pos1` / `Ende` | Erste / letzte Folie |
| `M` | Modus umschalten: **Workshop (2h)** ⇄ **Impuls (30min)** |
| `T` | Hell / Dunkel |
| `F` | Vollbild |
| `Ü` (Übersicht) / Klick auf Zähler | Folien-Übersicht |

**PPT ableiten:** Das Deck ist bewusst eigenständiges HTML. Für PowerPoint entweder pro Folie
in den Vollbild-/Präsentationsmodus gehen und exportieren/screenshotten, oder die Inhalte aus
`workshop-content.md` in eure Firmen-Vorlage übernehmen. Das HTML ist die Referenz-Fassung.

## Struktur (8 Sektionen, 28 Folien)

0. **Einstieg** — Opener „unsichtbare uncommittete Arbeit" → Kontext-Isolation
1. **Mentales Modell** — Agent = LLM + Werkzeuge + Schleife; Subagent-Isolation als Kernkonzept
2. **Einordnung** — was ist neu, was kennt ihr längst
3. **Fünf Pfeiler** — Verfassung · Team · Gedächtnis · Werkzeuge
4. **Roter Faden** — weiche vs. harte Durchsetzung → Hooks
5. **Prozess** — Task-Lifecycle, Handoff-Kette, Gates
6. **Nebenläufigkeit** — „deine Dev-Umgebung ist ein verteiltes System" (eigener Block)
7. **Hands-on** — Mini-System selbst bauen
8. **Abschluss** — skalieren + unsere offenen Probleme + Take-aways

## Hinweis zu Interna

Das Material ist für ein **externes** Publikum **anonymisiert**: keine Projekt-/Produktnamen,
keine internen Repo-Pfade, PR-Nummern oder Tool-Namen. Die Vorfälle sind real (intern belegt),
aber generisch beschrieben — die Lektionen bleiben, die identifizierenden Details sind entfernt.
Konkrete Tech-Stack-Namen wurden durch generische Kategorien ersetzt (z. B. „DB-Backend"
statt des konkreten Produkts).
