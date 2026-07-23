# Hands-on-Kit: Baut euer eigenes Mini-Agent-System

Ihr baut in ~40–60 Min ein minimales, aber **vollständiges** Claude-Code-Agent-System auf
einem Wegwerf-Repo — mit **einem Vertreter jedes der fünf Pfeiler** aus dem Workshop. Wenn
das läuft, habt ihr das Muster und könnt es auf euer echtes Projekt skalieren.

> Die App selbst ist bewusst trivial (eine In-Memory-Task-Liste). Der Lernstoff ist alles
> im `.claude/`-Ordner drumherum.

## Die fünf Zutaten → die fünf Pfeiler

| # | Zutat | Datei | Pfeiler |
|---|---|---|---|
| 1 | Projektverfassung mit 3 Regeln | `CLAUDE.md` | 1 · Verfassung |
| 2 | Zwei Subagenten mit **unterschiedlichen Rechten** | `.claude/agents/implementer.md`, `reviewer.md` | 2 · Team |
| 3 | Ein **Gate als Hook** (blockt Edits auf `main`) | `.claude/hooks/block-main-edits.sh` + `.claude/settings.json` | 4 · Werkzeuge / Roter Faden |
| 4 | Eine **Memory-Datei** | `.claude/memory/` | 3 · Gedächtnis |
| 5 | Ein **Worktree-Flow** | Übung 2 unten | 5 · Nebenläufigkeit |

Alles ist im Ordner `starter/` schon vorbereitet — ihr müsst nichts von Null tippen, sondern
es **verstehen, ausprobieren und kaputt machen**.

---

## Voraussetzungen

- **VS Code** mit der **Claude Code**-Extension (oder Claude Code im Terminal)
- **Node.js** ≥ 18 (für den eingebauten Test-Runner) und **git**
- **python3** (für den Hook — auf macOS/Linux vorinstalliert)

Prüfen:
```bash
node --version && git --version && python3 --version
```

---

## Schritt 0 — Starter in ein eigenes Repo holen

Kopiert `starter/` an einen Ort **außerhalb** dieses Repos und macht ein frisches git-Repo
draus (der Hook braucht ein echtes git-Repo mit `main`-Branch):

```bash
cp -r starter ~/agent-starter
cd ~/agent-starter
git init -b main
git add -A && git commit -m "init: agent-system starter"
npm test          # 3 Tests sollten grün sein
```

Öffnet `~/agent-starter` in VS Code und startet dort eine Claude-Code-Session.

> **Warum ein eigenes Repo?** Der Hook (Zutat 3) prüft den aktuellen git-Branch. Innerhalb
> eines anderen Repos würde er den falschen Branch sehen. Ein eigenes Repo = saubere Demo.

---

## Zutaten-Tour (2 Min lesen, bevor ihr loslegt)

Öffnet die Dateien und lest die Kommentare — sie erklären sich selbst:

- **`CLAUDE.md`** — drei Regeln. Achtet auf den Unterschied: Regel 2 ist eine **harte**
  Regel (per Hook erzwungen), Regel 3 eine **weiche** Leitplanke (nur eine Bitte).
- **`.claude/agents/implementer.md`** — hat `tools: Glob, Grep, Read, Edit, Write` → darf Code ändern.
- **`.claude/agents/reviewer.md`** — hat `tools: Glob, Grep, Read` → **kann physisch nicht
  schreiben**. Genau das ist „Rechte = Sicherheit".
- **`.claude/hooks/block-main-edits.sh`** + **`.claude/settings.json`** — der Hook und seine Verdrahtung.
- **`.claude/memory/`** — ein kuratierter Fakt + Index.

---

## Übung 1 — Die harte Regel spüren (Hook, ~10 Min)

Ihr seid auf `main`. Bittet Claude, den Code zu ändern:

> **Prompt:** „Füge in `src/tasks.js` eine Funktion `clearDone()` hinzu, die alle erledigten Tasks entfernt."

**Erwartet:** Der `PreToolUse`-Hook **blockiert** den Edit, bevor er passiert — mit der
Meldung „BLOCKED: keine Edits an src/ auf 'main'…". Das ist die harte Durchsetzung: egal wie
überzeugt das Modell ist, es *kann* nicht.

Vergleicht das mit Regel 3 (keine neuen Abhängigkeiten): Die steht nur in `CLAUDE.md` und ist
eine **Bitte** — das Modell hält sich meist daran, aber nichts erzwingt es. **Das ist der
Kern des roten Fadens: weiche vs. harte Durchsetzung.**

**Kaputt machen & verstehen:** Öffnet den Hook und ändert `src/` z.B. auf `tests/`. Was wird
jetzt blockiert, was nicht? (Danach zurückändern.)

---

## Übung 2 — Worktree + Handoff (Team, ~20 Min)

So macht ihr die Änderung *richtig* — im Worktree, über die Agenten.

**a) Worktree anlegen** (Zutat 5, der Nebenläufigkeitsschutz):
```bash
git worktree add ../starter-clear-done -b clear-done
```
Öffnet `../starter-clear-done` als zweiten Ordner. Jetzt seid ihr auf Branch `clear-done` —
der Hook lässt `src/`-Edits hier durch.

**b) Implementer beauftragen:**

> **Prompt:** „Dispatch den implementer-Agenten: Er soll `clearDone()` in `src/tasks.js` implementieren und einen Test in `tasks.test.js` ergänzen. Danach `npm test` laufen lassen."

Achtet darauf: Der implementer arbeitet in **eigenem Kontext**. Am Ende fasst er zusammen,
was er geändert hat — weil der reviewer seinen Kontext **nicht sieht**.

**c) Reviewer beauftragen:**

> **Prompt:** „Dispatch den reviewer-Agenten: Er soll die Änderung an `clearDone()` prüfen — Korrektheit, Einfachheit, CLAUDE.md-Regeln."

**Erwartet:** Der reviewer gibt ein Urteil (`PASS` / `CHANGES REQUESTED`) als Text zurück —
**er ändert nichts**, weil ihm Edit/Write fehlen. Selbst wenn ihr ihn bittet, den Code zu
„fixen", kann er es nicht. Das ist die Team-Isolation + Rechte-als-Sicherheit am eigenen Leib.

**Kaputt machen & verstehen:** Bittet den reviewer ausdrücklich, den Bug selbst zu beheben.
Beobachtet, wie er es nicht kann und stattdessen beschreibt, was zu tun ist.

---

## Übung 3 — Gedächtnis (Memory, ~5 Min)

> **Prompt:** „Ich brauche einen ordentlichen Test-Runner. Installier bitte Jest."

**Erwartet:** Ein Agent, der `.claude/memory/prefer-node-builtins.md` liest, **widerspricht**
und verweist auf die dependency-freie Regel — statt blind `npm install jest` vorzuschlagen.
Das ist persistentes, kuratiertes Wissen, das eine Fehlentscheidung verhindert.

Fügt selbst einen Fakt hinzu (eine Datei in `.claude/memory/` + eine Zeile in `MEMORY.md`)
und seht, ob ein Agent ihn in einer neuen Session berücksichtigt.

---

## Übung 4 — Die Kollision (Nebenläufigkeit, ~10 Min)

Jetzt macht ihr den Distributed-Systems-Effekt aus dem Workshop **sichtbar**.

1. Öffnet **zwei** VS-Code-Fenster auf **demselben** `~/agent-starter` (nicht dem Worktree!),
   in jedem eine Claude-Code-Session.
2. Bittet **Fenster A**, `src/tasks.js` zu ändern — aber **nicht** zu committen. (Auf einem
   Feature-Branch, damit der Hook nicht blockt.)
3. Bittet **Fenster B**, dieselbe Datei zu lesen und darauf aufzubauen.

**Beobachtung, je nach Setup:**
- Teilen sich beide **dieselbe Arbeitskopie**, sieht B die auf Platte gespeicherte (aber
  uncommittete) Änderung von A — die Grenze ist „auf Platte", nicht „committet".
- Arbeiten sie in **getrennten Worktrees**, sieht B A's Arbeit **gar nicht**, bis A committet
  **und** B merged/synced.

Genau das ist der Punkt: **Sobald mehr als eine Session läuft, ist eure Umgebung ein
verteiltes System.** Die Gegenmittel sind dieselben, die ihr kennt: oft committen, Isolation
(Worktrees), Single-Writer für geteilten State.

---

## Zurückführen auf die fünf Pfeiler

| Ihr habt erlebt … | … das ist Pfeiler |
|---|---|
| Regeln, die jede Session gelten | 1 · Verfassung |
| implementer schreibt, reviewer nicht | 2 · Team (Rechte = Sicherheit) |
| Ein Fakt verhindert eine Fehlentscheidung | 3 · Gedächtnis |
| Der Hook blockt hart, CLAUDE.md bittet weich | 4 · Werkzeuge / Roter Faden |
| Zwei Fenster, ein Repo → Kollision | 5 · Nebenläufigkeit |

## Vom Mini zum echten System

Wachst **entlang des Schmerzes**, nicht auf Vorrat:
1. Erst **Routing + Worktrees** (Team + Isolation).
2. Dann **Hooks** für das Katastrophale (was hart erzwungen werden muss).
3. Dann **Memory** (wiederkehrende Lektionen festhalten).
4. Zuletzt **Nebenläufigkeits-Schutz** (Single-Writer, IDs, Locks), wenn das Team wächst.

Nicht mit 18 Agenten und 30 Regeln starten — jede Regel sollte aus einem echten Vorfall entstehen.

---

## Spickzettel

```bash
# Worktree-Flow
git worktree add ../starter-<branch> -b <branch>   # anlegen
#   … im Worktree arbeiten, committen …
git worktree remove ../starter-<branch>            # nach Merge aufräumen

# App testen
npm test                                           # node --test, keine Deps

# Hook manuell testen (blockt src/ auf main)
printf '{"tool_input":{"file_path":"'"$PWD"'/src/tasks.js"}}' | .claude/hooks/block-main-edits.sh; echo "exit=$?"
```

**Agent-Definition (Muster):**
```yaml
---
name: reviewer
description: Wann Claude an diesen Agenten delegieren soll.
tools: Glob, Grep, Read      # Allowlist — weggelassen = erbt ALLE Werkzeuge
model: inherit                # oder sonnet / opus / haiku
---
System-Prompt des Agenten (Markdown-Body).
```

**Hook blockieren (Contract):** Tool-Aufruf kommt als JSON auf stdin → zum Blocken `exit 2`
und Grund auf **stderr**. Erlauben = `exit 0`. (Strukturierte Alternative: JSON mit
`permissionDecision:"deny"` auf stdout, `exit 0`.)
