---
name: prefer-node-builtins
description: Keep this repo dependency-free — use Node built-ins over external packages.
metadata:
  type: project
---

Dieses Starter-Repo bleibt bewusst **dependency-frei** (siehe CLAUDE.md Regel 3).
Tests laufen mit dem eingebauten `node:test`-Runner und `node:assert` — **nicht** Jest/Vitest.
Scheint eine Aufgabe ein Paket zu brauchen, erst einen Node-Builtin oder ein paar Zeilen
lokalen Code prüfen.

Dies ist auch das Demo-Beispiel für Pfeiler 3: Ein kuratierter Fakt, den ein Agent liest,
BEVOR er (fälschlich) `npm install jest` vorschlägt.
