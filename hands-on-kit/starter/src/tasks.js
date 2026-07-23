// Tiny in-memory task list — the throwaway app for the agent-system demo.
// Deliberately minimal: the point of this repo is the agent setup around it
// (.claude/), not the app itself. Dependency-free on purpose (see CLAUDE.md).

let nextId = 1;
const tasks = [];

function addTask(title) {
  if (!title || !title.trim()) throw new Error('title required');
  const task = { id: nextId++, title: title.trim(), done: false };
  tasks.push(task);
  return task;
}

function completeTask(id) {
  const task = tasks.find((t) => t.id === id);
  if (!task) throw new Error(`task ${id} not found`);
  task.done = true;
  return task;
}

function listTasks({ includeDone = true } = {}) {
  return tasks.filter((t) => includeDone || !t.done);
}

function reset() {
  tasks.length = 0;
  nextId = 1;
}

module.exports = { addTask, completeTask, listTasks, reset };
