// Runs with the built-in Node test runner: `npm test` (== `node --test`).
// No test framework installed on purpose — see .claude/memory/prefer-node-builtins.md.

const { test } = require('node:test');
const assert = require('node:assert');
const { addTask, completeTask, listTasks, reset } = require('./src/tasks');

test('addTask returns a task with an id', () => {
  reset();
  const t = addTask('write slides');
  assert.equal(t.title, 'write slides');
  assert.equal(t.done, false);
  assert.ok(t.id > 0);
});

test('completeTask marks a task done', () => {
  reset();
  const t = addTask('review PR');
  completeTask(t.id);
  assert.equal(listTasks()[0].done, true);
});

test('listTasks can hide done tasks', () => {
  reset();
  const a = addTask('a');
  addTask('b');
  completeTask(a.id);
  assert.equal(listTasks({ includeDone: false }).length, 1);
});
