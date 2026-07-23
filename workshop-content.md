# Agentische Entwicklung — Content-Gerüst (Sprecher-Notizen)

> Editierbare Quelle für das HTML-Deck (`workshop-deck.html`). Eine Sektion pro Slide.
> Jede Slide: **Auf der Folie** (Kurzinhalt) · **Sprecher-Notizen** · ggf. **Diagramm** · `[IMPULS]`-Marker.
> `[IMPULS]` = Teil des 30-Min-Impulsvortrags (Teilmenge des 2h-Workshops). Alles andere = nur 2h-Workshop.
>
> Zielgruppe: erfahrene Devs, **neu bei Agenten**. IDE: VS Code. Sie bauen ihr **eigenes** System.
> Roter Faden: **weiche vs. harte Durchsetzung** (CLAUDE.md = Bitte, Hook = Gesetz).
> Kernkonzept, aus dem alles folgt: **Kontext-Isolation von Subagenten**.

---

## SEKTION 0 · EINSTIEG

### Slide 1 — Titel `[IMPULS]`
**Auf der Folie:** „Agentische Entwicklung — ein Multi-Agent-Dev-System bauen und betreiben." Untertitel: Was wir in einem realen Produktivprojekt gelernt haben — und wie ihr es auf euer System übertragt. Für erfahrene Devs, neu bei Agenten.

**Sprecher-Notizen:** Rahmen setzen: Das hier erklärt zwei Dinge gleichzeitig — (A) was agentische Entwicklung *ist*, (B) wie *unser konkretes* System sie umsetzt. Der eine Satz zum Mitnehmen: „Wir haben Claude nicht schlauer gemacht — wir haben ihm eine Prozessorganisation gegeben." Kurz die zwei Formate ansagen (30-Min-Impuls ⊂ 2h-Workshop, gleiche Quelle — Modus-Umschalter `M`).

---

### Slide 2 — Die Wunde (Opener) `[IMPULS]`
**Auf der Folie:** „Wo ist mein Code hin?" — Agent A ändert eine Datei, committet nicht. Agent B liest dieselbe Datei, sieht die Änderung nicht, baut auf dem alten Stand weiter. Zusammenführen → Konflikt, Doppelarbeit, teils verlorene Arbeit.

**Sprecher-Notizen:** Nicht mit Theorie starten, mit Schmerz. Diese Geschichte ist echt und wiederholt sich in unserem Repo (Commit-Gate in CLAUDE.md existiert genau deswegen). Pointe erst am Ende: Das ist **kein Tooling-Bug**, das ist die Grundmechanik agentischer Systeme. Genau deshalb lohnt der Rest des Vortrags.
**Reserve-Stories** (auf Nachfrage / bei mehr Zeit): (1) ein falsch verschachteltes UI-Framework-Pattern → 8h Debugging → Docs-First-Regel; (2) eine Infrastruktur-Automatik grantete stillschweigend volle DB-Rechte → „das System tut heimlich etwas, das keiner angeordnet hat".

---

### Slide 3 — Was gerade passierte `[IMPULS]`
**Auf der Folie:** Jeder Agent hat sein eigenes Gedächtnis. Agent B war nicht dumm — er *konnte* A's Arbeit nicht sehen. Drei Sätze: (1) Kontext ist pro-Agent isoliert. (2) Was nicht committet ist, existiert für andere nicht. (3) Fast jede Regel unseres Systems folgt aus diesen zwei Sätzen.

**Sprecher-Notizen:** Das ist die Brücke vom Opener ins Kernkonzept. Betonen: Wir werden gleich sehen, dass die halbe CLAUDE.md aus diesen zwei Sätzen ableitbar ist — man muss die Regeln nicht auswendig lernen, man kann sie *herleiten*.

---

## SEKTION 1 · MENTALES MODELL

### Slide 4 — Was ist ein Agent? `[IMPULS]`
**Auf der Folie:** Agent = LLM + Werkzeuge + Schleife. Ein LLM, das Werkzeuge aufrufen darf (Dateien, Shell, Web) und in einer Schleife arbeitet, bis die Aufgabe erledigt ist. Chatbot *antwortet* — Agent *handelt*.

**Sprecher-Notizen:** Für dieses Publikum in 2 Minuten durch. Der einzige wichtige Punkt: Weil ein Agent handelt (Dateien schreibt, Befehle ausführt), muss er kontrolliert werden wie ein Mitarbeiter, nicht genutzt wie eine Suchmaschine. Das motiviert alles Folgende.

---

### Slide 5 — Subagenten & Kontext-Isolation `[IMPULS]`
**Auf der Folie:** Main-Agent koordiniert. Jeder Subagent bekommt eigenen Kontext + eigene Werkzeuge + eine Rolle. Subagenten sehen weder einander noch den vollen Verlauf.
**Diagramm:** Main-Kontext-Blase oben, darunter 3 getrennte Subagent-Blasen (implementer / reviewer / researcher), keine Verbindung untereinander, nur je eine Linie zum Main.

**Sprecher-Notizen:** DAS ist das Kernkonzept. Langsam machen. Analogie: Wie ein Tech-Lead, der drei Devs je ein isoliertes Ticket gibt — jeder sieht nur sein Ticket, nicht die Chats der anderen. Der Lead (Main) fügt zusammen. Isolation ist Absicht: Fokus + begrenzte Fehlerfläche.

---

### Slide 6 — Isolation ist Feature UND Fluch
**Auf der Folie:** FEATURE: Fokus, kein Rauschen, parallelisierbar, begrenzte Fehlerfläche. FLUCH: blind für die Arbeit der anderen, „vergisst" über Sessions, braucht explizite Übergabe. → Aus dem Fluch folgen: schriftliche Reports, Commit-Gate, persistentes Memory.

**Sprecher-Notizen:** Hier wird das Konzept produktiv. Jede der drei „Fluch"-Konsequenzen ist eine konkrete Regel bei uns. Die Devs sollen merken: Die Regeln sind keine Bürokratie, sie sind die Gegenmaßnahmen zur Isolation.

---

## SEKTION 2 · EINORDNUNG

### Slide 7 — Neu vs. bekannt `[IMPULS]`
**Auf der Folie:** Zweispaltige Tabelle.
| Fühlt sich neu an, ist Altbekanntes | Wirklich neu |
|---|---|
| Agent-Team = Separation of Concerns / Microservices | Kontextverlust als Fehlerklasse |
| Gates = CI-Gates / pre-commit hooks | Agenten sehen uncommittete Arbeit nicht |
| Worktrees = Feature-Branches | Plausibel-aber-falsch: überzeugender Unsinn |
| Routing = Dispatcher / Code-Owner | Persistentes Memory als gepflegtes Asset |

**Sprecher-Notizen:** Der wertvollste didaktische Move für erfahrene Devs. Sie verschwenden Aufmerksamkeit links und unterschätzen rechts. Ansage: „Die linke Spalte hakt ihr in Minuten ab. Die rechte Spalte ist der eigentliche Lernstoff." Besonders „plausibel-aber-falsch" betonen — Output, der überzeugend aussieht und trotzdem Unsinn ist, ist die gefährlichste neue Fehlerklasse.

---

## SEKTION 3 · DIE FÜNF PFEILER

### Slide 8 — Überblick: Fünf Pfeiler `[IMPULS]`
**Auf der Folie:** 1 Verfassung (CLAUDE.md) · 2 Team (Subagenten) · 3 Gedächtnis (Memory) · 4 Werkzeuge (MCP/Skills) · 5 Nebenläufigkeit. Hinweis: 1–4 bauen das System, 5 hält es zusammen, sobald mehr als eine Session läuft.

**Sprecher-Notizen:** Landkarte für den Rest. Pfeiler 5 ist bewusst hervorgehoben — das ist der Teil, den fast alle Einführungen vergessen und der euch als Team am härtesten trifft.

---

### Slide 9 — Pfeiler 1: Verfassung (CLAUDE.md)
**Auf der Folie:** Wird jede Session geladen. Regeln, die Standardverhalten überschreiben. Beispiele: Routing-Matrix, Code-Regeln (User-Isolation, kein `console.*`), Worktree-Pflicht, Shell-Patterns. Prinzip: kurz, überschneidungsfrei, jede Regel begründet.

**Sprecher-Notizen:** Wichtig: Es ist ein **Prompt, kein Wiki**. Jedes Wort kostet Kontext und Aufmerksamkeit des Modells. Anti-Pattern: die CLAUDE.md als Dokumentenhalde. Faustregel für die Devs: Wenn eine Regel sich ändern muss, sobald sich der Code ändert → gehört in den Code, nicht in CLAUDE.md.

---

### Slide 10 — Pfeiler 2: Team
**Auf der Folie:** ~18 Spezialisten: frontend, services, backend, security, compliance, devops, architect, quality, design, ux … Jeder hat **eingeschränkte Werkzeuge**. Ein Review-Agent hat kein Bash. Rechte = Sicherheit.
**Diagramm:** Main-Agent oben, darunter Gitter aus Spezialisten-Kacheln, einige mit „kein Write"/„kein Bash"-Markierung.

**Sprecher-Notizen:** Der Schlüssel für die Devs: Werkzeug-Rechte pro Rolle sind kein Detail, sondern Sicherheitsdesign. Ein Compliance-Agent, der auditieren aber nichts schreiben soll, bekommt kein Write/Bash. So kann selbst ein „überzeugter" Agent keinen Schaden anrichten, für den er keine Werkzeuge hat.

---

### Slide 11 — Pfeiler 3: Gedächtnis
**Auf der Folie:** Auto-Memory (Index `MEMORY.md` + Fakt-Dateien) + `agent-memory` pro Agent. Ein Fakt pro Datei, Frontmatter, verlinkt. Aktiv kuratiert — kein Log. Warnung: Memory-Dateien **committen**, sonst sehen parallele Sessions die Lektion nicht.

**Sprecher-Notizen:** Persistentes Memory ist die Antwort auf „Agent vergisst über Sessions". Wichtig die Kuratierung betonen: falsche Memories werden gelöscht, nicht angehäuft. Und die Nebenläufigkeits-Falle (uncommittetes Memory) hier schon andeuten — kommt in Pfeiler 5 wieder.

---

### Slide 12 — Pfeiler 4: Werkzeuge
**Auf der Folie:** MCP-Server (Wiki, DB-Backend, Browser-DevTools, Zahlungsanbieter-Anbindung), Skills (paketierte Abläufe), Hooks. Prinzip: Werkzeuge sind Fähigkeit *und* Angriffsfläche — nur geben, was die Rolle braucht.

**Sprecher-Notizen:** MCP kurz erklären: standardisierte Schnittstelle, über die ein Agent externe Systeme bedient (DB, Browser, Zahlungsanbieter). Skills = wiederverwendbare Abläufe. Überleitung zu Hooks: das ist das Werkzeug, mit dem wir Regeln *erzwingen* — nächster Block.

---

## SEKTION 4 · ROTER FADEN: WEICHE VS. HARTE DURCHSETZUNG

### Slide 13 — Weiche vs. harte Durchsetzung `[IMPULS]`
**Auf der Folie:** CLAUDE.md-Regel = **Bitte** (das Modell *sollte*, probabilistisch). Hook = **Gesetz** (die Harness *erzwingt*, deterministisch). Kunst: nur die wenigen katastrophalen + leicht verletzten Regeln hart machen.
**Diagramm:** Links „Bitte" (gestrichelte Barriere, Modell kann durchgehen). Rechts „Gesetz" (durchgezogene Barriere, blockt hart).

**Sprecher-Notizen:** Der load-bearing Gedanke, der Hooks + Gates + CLAUDE.md zu *einer* Idee verschmilzt. Entspricht dem Dev-Instinkt: don't trust, verify. Konkret: Wir haben ~30 Regeln, nur eine Handvoll ist Hook-erzwungen.

---

### Slide 14 — Hooks
**Auf der Folie:** Kennt ihr von git: `pre-commit` blockt einen Commit. Claude-Code-Hooks blocken/prüfen **Tool-Aufrufe**: `PreToolUse`, `PostToolUse` … Beispiel: `block-main-edits.sh` blockt Edits an `src/` auf `main` — deterministisch, egal was das Modell „will".

**Sprecher-Notizen:** Hooks sind für dieses Publikum wahrscheinlich NEU — Brücke von git-hooks, die sie kennen. Der Unterschied: git-hooks hängen an git-Events, Claude-Code-Hooks an Tool-Events (jeder Datei-Edit, jeder Bash-Aufruf). Das ist die einzige *deterministische* Kontrolle im ganzen System.

---

### Slide 15 — Welche Regel macht man hart?
**Auf der Folie:** Achse Schaden (niedrig→hoch) × Verletzungswahrscheinlichkeit (niedrig→hoch). Nur **hoch × hoch** → Hook. Rest → Leitplanke in CLAUDE.md. ~30 Regeln, nur eine Handvoll Hooks.

**Sprecher-Notizen:** Übertragbares Design-Prinzip für ihr eigenes System: Mechanik ist teuer (Wartung, Reibung, false positives). Erzwinge mechanisch nur, was katastrophal UND leicht zu verletzen ist. Beispiel katastrophal+leicht: direkt auf main editieren. Beispiel nicht-hart: „nutze aussagekräftige Commit-Messages".

---

## SEKTION 5 · PROZESS

### Slide 16 — Task-Lifecycle
**Auf der Folie:** Routing → Worktree → Handoff-Kette → Gates → Commit → PR. Nichts wird direkt auf `main` editiert. Nichts geht ungeprüft raus.
**Diagramm:** Horizontale Pipeline mit 6 Stationen.

**Sprecher-Notizen:** Ein echter Durchlauf, damit es greifbar wird. Beispiel-Task nennen (z.B. „neue Nutrition-Seite"). Betonen: Routing-Matrix entscheidet den Zuständigen — nicht raten.

---

### Slide 17 — Handoff-Kette
**Auf der Folie:** design → frontend → security → design (Styling) → testing → quality → audit → compliance → sign-off. Jede Übergabe ist explizit + schriftlich.
**Diagramm:** Kette aus Knoten, jeder Pfeil beschriftet mit dem Artefakt der Übergabe.

**Sprecher-Notizen:** „Schriftlich" ist die direkte Folge der Kontext-Isolation (Slide 5/6): Der nächste Agent sieht nur, was als Datei/Report vorliegt — nicht den Chat des vorigen. Deshalb die Review-Artifact-Regel: jeder Review erzeugt eine Datei, kein Inline-Report.

---

### Slide 18 — Gates als Immunantwort
**Auf der Folie:** Pre-Edit-Gate, Commit-Gate, Post-Agent-Gate, Review-Artifact-Regel. Warum so viel? Ein Mensch, der User-Isolation vergisst, fällt im Review auf. Ein Agent produziert 200 Zeilen konsistenten Code mit demselben Fehler — der nächste baut darauf auf.

**Sprecher-Notizen:** Hier die Skepsis frontal adressieren („so viel Prozess für einen Chatbot?"). Die Gates sind die Ersatz-Immunantwort für ein System, dem das menschliche „Moment mal…"-Bauchgefühl fehlt. Wenn sie das einmal verstanden haben, kippt Skepsis in Verständnis.

---

## SEKTION 6 · NEBENLÄUFIGKEIT (eigener Block)

### Slide 19 — Der 5. Pfeiler `[IMPULS]`
**Auf der Folie:** Deine Dev-Umgebung ist ein verteiltes System. Ein Dev, eine Session → einfach. 4 Devs × 2 Sessions auf einem Repo, einer Staging-DB, einer CI → Race Conditions. Ihr kennt das Problem — es trifft euch nur auf einer neuen Ebene.

**Sprecher-Notizen:** Der Block, den der Auftraggeber besonders betont hat. Für erfahrene Devs der interessanteste, weil sie es sofort als vertrautes Distributed-Systems-Problem wiedererkennen. Setup-Frage in den Raum: „Vier von euch, je zwei Sessions offen — was bricht?"

---

### Slide 20 — Zwei-Fenster-Demo
**Auf der Folie:** Zwei VS-Code-Fenster, dasselbe Repo, je eine Claude-Code-Session. Fenster A editiert, committet nicht. Fenster B liest denselben Stand (stale), baut weiter. Zusammenführen → Kollision. Derselbe Mechanismus wie im Opener — nur zwischen *Sessions* statt zwischen *Agenten*.
**Diagramm:** Sequenz-artig: zwei Spalten (Fenster A / Fenster B), Zeitachse nach unten, divergierende Stände, Kollision am Ende.

**Sprecher-Notizen:** Schöne Klammer zum Opener — derselbe Fehler, eine Ebene höher. VS-Code-konkret machen, weil das ihr Alltag wird: zwei Fenster/Terminals = zwei Sessions auf einem Arbeitsverzeichnis. Lösung ist dieselbe Familie: oft committen + Isolation (Worktree) + Single-Writer für geteilten State.

---

### Slide 21 — Kollisionsebenen → Prinzipien `[IMPULS]`
**Auf der Folie:** Tabelle.
| Ebene | Unser Symptom | Prinzip (kennt ihr) |
|---|---|---|
| Git/Dateisystem | 2 Sessions editieren `src/`, uncommittet unsichtbar | Isolation + oft committen |
| Geteilter State | 2 Sessions schreiben `PLAN.md` | Single-Writer |
| ID-Kollision | beide greifen Migration `N` | kollisionsresistente IDs (`N-b`) |
| Live-Ressource | beide wollen denselben Port | Resource Lock (→ Fallback-Port) |
| Optimistic | beide publizieren dasselbe Artefakt | baseVersion / 409 |
| Idempotenz | Insert läuft doppelt | `ON DUPLICATE KEY UPDATE` |

**Sprecher-Notizen:** Jede Zeile ist ein realer Vorfall bei uns → auf ein Prinzip abgebildet, das sie aus verteilten Systemen kennen. Kernsatz: „Sobald >1 Session läuft, ist deine Coding-Umgebung ein verteiltes System — behandle sie wie eines."

---

### Slide 22 — Drei echte Vorfälle
**Auf der Folie:** Drei Karten.
1. **`INSERT IGNORE` → ~20 DB-Objekte still korrumpiert.** File N+5 korrigiert File N — `IGNORE` verwarf die Korrektur schweigend. „Grün, keine Fehler, trotzdem kaputt." Fix: `ON DUPLICATE KEY UPDATE`.
2. **Dev-Server servierte 2× den falschen Worktree.** Geteilter Prozess an fremden Branch gepinnt (CWD nicht-deterministisch) — und das Task-Briefing behauptete fälschlich „confirmed".
3. **Nummern-Kollisionen (`N-b` / `N-a…d`) + Datei-Drift (> 100 Zeilen Unterschied).** Zwei Autoren, ein Artefakt.

**Sprecher-Notizen:** Alle drei sind reale, intern belegte Vorfälle (hier für externes Publikum anonymisiert). #1 ist die stärkste — stille Datenkorruption. #2 zeigt: die Kollision *lügt dich an* (falsches „confirmed"). #3 = zwei Autoren greifen nach demselben Artefakt.

---

### Slide 23 — Meta: CLAUDE.md IST eine DS-Schicht
**Auf der Folie:** Chips: Single-Writer (ein Agent besitzt Plan) · Mutex (Command-Ownership) · Optimistic Lock (baseVersion) · Idempotenz (ON DUP KEY) · Resource Lock (Ports) · Kollisionsfeste IDs (Nummern-Suffixe). Kicker: nur nicht so etikettiert.

**Sprecher-Notizen:** Die Pointe, die erfahrene Devs abholt: „Ihr kennt das alles schon — ihr müsst es nur *sehen* und benennen." Sie bauen diese Primitive gerade in ihr eigenes System ein.

---

## SEKTION 7 · HANDS-ON

### Slide 24 — Baut euer eigenes Mini-System
**Auf der Folie:** Wegwerf-Repo, neutrale App. Ein Vertreter *jedes* Pfeilers. Wenn das läuft, habt ihr das Muster. Setup: VS Code + Claude Code, ein leeres Repo.

**Sprecher-Notizen:** Scoping-Ansage: Wir lehren nicht die Breite, sondern den minimalen selbsttragenden Kern. „Verstehen durch Nachbauen im Kleinen" schlägt „alles erklärt bekommen". Zeitbudget im Workshop: ~40–60 Min Hands-on.

---

### Slide 25 — Die fünf Zutaten
**Auf der Folie:** Fünf Dateien, ein System:
1. `CLAUDE.md` mit 3 Regeln
2. Zwei Subagenten: `implementer` + `reviewer` — *unterschiedliche* Rechte (reviewer ohne Write)
3. Ein Gate als Hook: blockiere Edits auf `main`
4. Eine Memory-Datei
5. Ein Worktree-Flow
Schritt für Schritt im Kit → `hands-on-kit/README.md`.

**Sprecher-Notizen:** Zutat 3 (der Hook) nimmt bewusst *eine* Kollisionsebene mit rein — „blockiere Edits auf main" ist ein Nebenläufigkeitsschutz. So bleibt Pfeiler 5 nicht Theorie. Reviewer-ohne-Write demonstriert Pfeiler 2 (Rechte = Sicherheit) am eigenen Leib.

---

## SEKTION 8 · ABSCHLUSS

### Slide 26 — Vom Mini zum echten System
**Auf der Folie:** Wachst entlang des Schmerzes, nicht auf Vorrat. Jede Regel entsteht aus einem konkreten Vorfall. Reihenfolge: erst Routing + Worktrees → dann Hooks für das Katastrophale → dann Memory → zuletzt Nebenläufigkeits-Schutz, wenn das Team wächst.

**Sprecher-Notizen:** Warnung vor Over-Engineering: Nicht mit 18 Agenten und 30 Regeln starten. Unser System ist über Monate *reaktiv* gewachsen. Jede Regel hat eine Vorfall-Geschichte.

---

### Slide 27 — Was wir noch NICHT gelöst haben
**Auf der Folie:** Geteilte Staging-Datenbank (mehrere Sessions, eine DB) · CI-Runner-Contention · stale-base-Plan-Gate-Deadlocks · Build-Datei-Drift (z. B. Dockerfile-COPY, keine CI-Prüfung, 3× aufgetreten). Ehrlichkeit > geglättete Erfolgsstory.

**Sprecher-Notizen:** Bewusst die offenen Baustellen zeigen. Für ein Team, das sein eigenes System baut, ist „hier ist, was wir noch nicht gelöst haben" wertvoller als eine Hochglanz-Story — sie können unsere offenen Probleme von Anfang an vermeiden.

---

### Slide 28 — Was ihr mitnehmt `[IMPULS]`
**Auf der Folie:**
1. Agenten sind isolierte Mitarbeiter — Übergaben müssen explizit sein.
2. CLAUDE.md *bittet*, Hooks *erzwingen* — macht das Katastrophale hart.
3. Ab Session zwei ist es ein verteiltes System — behandelt es wie eines.
4. Jede Regel ist geronnene Erfahrung, kein Ideal.
Schluss: Jetzt baut ihr es. → Kit.

**Sprecher-Notizen:** Im Impuls-Modus ist das die Abschluss-Folie mit Cliffhanger: „Im Workshop baut ihr das selbst." Im Workshop leitet sie direkt ins Hands-on über (falls Abschluss vor Hands-on) bzw. schließt ab.

---

## Anhang · Reserve-Material (auf Nachfrage)

- **UI-Framework-Pattern-8h-Story** → Docs-First-Regel: ein falsch verschachteltes Routing-/Tabs-Pattern, 8h Debugging. Lektion: nie auf trainiertes Wissen verlassen, immer aktuelle Doku laden.
- **Infrastruktur-Auto-Grant** → „das System tut heimlich etwas": eine Infrastruktur-Automatik grantete dem DB-User automatisch volle Rechte; ein späterer Grant-Shrink hielt nie stabil; Fix entfernt die Auto-Grant-Quelle.
- **Weitere Kollisions-Vorfälle** (Reserve für Nebenläufigkeits-Block): stale-base failt das Plan-Gate; ein path-gefilterter „required" CI-Check deadlockte Infra-PRs; gestrandete `agent-memory`-Files „aus Worktree verschoben"; Terminal-Command-Ownership-Mutex; „max 3 parallele Agenten" wegen MCP-Konflikten; `npm --prefix <worktree>` testete heimlich `main` statt Worktree (grün, aber falscher Branch).
