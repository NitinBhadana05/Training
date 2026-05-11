"use client";

import { useState } from "react";
import type { Task } from "@/types/task";

export default function TaskForm({
  onTaskCreated,
}: {
  onTaskCreated: (task: Task) => void;
}) {
  const [title, setTitle] = useState("");
  const [dueDate, setDueDate] = useState("");

  const createTask = async () => {
    if (!title) return;

    const res = await fetch("/api/task", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        title,
        dueDate:
          dueDate.length > 0
            ? dueDate
            : null,
        status: "TODO",
      }),
    });

    if (!res.ok) {
      return;
    }

    const task = (await res.json()) as Task;

    setTitle("");
    setDueDate("");
    onTaskCreated(task);
  };

  return (
    <div className="rounded-3xl border border-[var(--border)] bg-[var(--surface)] p-4 shadow-sm">
      <div className="grid gap-3 md:grid-cols-[1fr_220px_auto]">
        <input
          value={title}
          onChange={(e) =>
            setTitle(e.target.value)
          }
          placeholder="Add a new task..."
          className="w-full rounded border border-zinc-300 bg-white p-3 text-zinc-900 placeholder:text-zinc-500"
        />

        <input
          value={dueDate}
          onChange={(e) =>
            setDueDate(e.target.value)
          }
          type="datetime-local"
          className="w-full rounded border border-zinc-300 bg-white p-3 text-zinc-900"
        />

        <button
          onClick={createTask}
          className="rounded bg-blue-700 px-5 py-3 text-white transition-colors hover:bg-blue-800 active:bg-blue-900"
        >
          Add
        </button>
      </div>
    </div>
  );
}
