# CLAUDE.md — Agent-System Starter

> Loaded every session. Rules here override default behavior. Keep it short — this is a
> prompt, not a wiki. (Pfeiler 1: Verfassung.)

## Regel 1 — Route before implementing  (Pfeiler 2: Team)
- Code-Änderungen (Funktionen, Fixes, Tests) laufen über den **implementer**-Agenten.
- Reviews laufen über den **reviewer**-Agenten. Der reviewer darf **nicht** schreiben —
  er beurteilt nur. (Rechte = Sicherheit.)

## Regel 2 — Nie direkt auf `main` editieren  (harte Regel, per Hook erzwungen)
- Vor jeder Code-Änderung einen Worktree anlegen: `git worktree add ../starter-<branch> -b <branch>`.
- Edits an `src/` auf `main` werden vom PreToolUse-Hook **blockiert** — nicht nur gebeten.
- (Pfeiler 4/Roter Faden: weiche vs. harte Durchsetzung. Diese Regel ist ein *Gesetz*.)

## Regel 3 — Keine neuen Abhängigkeiten  (weiche Regel, Leitplanke)
- Die App bleibt dependency-frei — nur Node-Builtins (`node:test`, `node:assert`).
- Braucht eine Aufgabe scheinbar ein Paket, erst nach einer Builtin-Lösung suchen.

---

Gelernte Fakten stehen in `.claude/memory/` — Index in `.claude/memory/MEMORY.md`.
Prüfe ihn, bevor du Annahmen über dieses Repo triffst. (Pfeiler 3: Gedächtnis.)
