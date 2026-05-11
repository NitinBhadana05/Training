"use client";

import { useDroppable } from "@dnd-kit/core";
import {
  SortableContext,
  verticalListSortingStrategy,
} from "@dnd-kit/sortable";
import type {
  Task,
  TaskStatus,
} from "@/types/task";
import SortableTask from "./sortable-task";

export default function KanbanColumn({
  status,
  title,
  description,
  tasks,
  onToggle,
  onDelete,
}: {
  status: TaskStatus;
  title: string;
  description: string;
  tasks: Task[];
  onToggle: (
    id: string,
    completed: boolean
  ) => void;
  onDelete: (id: string) => void;
}) {
  const { setNodeRef, isOver } =
    useDroppable({
      id: status,
    });

  return (
    <section className="min-w-0 overflow-hidden rounded-3xl border border-[var(--border)] bg-[var(--surface)] shadow-sm">
      <div className="border-b border-[var(--border)] bg-[var(--surface-muted)] px-5 py-4">
        <p className="text-sm font-semibold uppercase tracking-[0.2em] text-[var(--accent)]">
          {title}
        </p>
        <p className="mt-2 text-sm text-[var(--muted-foreground)]">
          {description}
        </p>
        <p className="mt-3 inline-flex rounded-full bg-white px-3 py-1 text-xs font-semibold text-zinc-700">
          {tasks.length} task{tasks.length === 1 ? "" : "s"}
        </p>
      </div>

      <SortableContext
        items={tasks.map((task) => task.id)}
        strategy={verticalListSortingStrategy}
      >
        <div
          ref={setNodeRef}
          className={`min-h-64 space-y-3 p-5 transition-colors ${
            isOver
              ? "bg-blue-50"
              : "bg-white"
          }`}
        >
          {tasks.length === 0 ? (
            <div className="rounded-2xl border border-dashed border-[var(--border)] bg-white/70 p-4 text-sm text-[var(--muted-foreground)]">
              Drop a task here
            </div>
          ) : (
            tasks.map((task) => (
              <SortableTask
                key={task.id}
                task={task}
                onToggle={onToggle}
                onDelete={onDelete}
              />
            ))
          )}
        </div>
      </SortableContext>
    </section>
  );
}
