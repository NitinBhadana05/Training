"use client";

import type { Task } from "@/types/task";
import { useSortable } from "@dnd-kit/sortable";
import { CSS } from "@dnd-kit/utilities";
import { isPast } from "date-fns";

const dueDateFormatter =
  new Intl.DateTimeFormat("en-GB", {
    day: "2-digit",
    month: "2-digit",
    year: "numeric",
    hour: "2-digit",
    minute: "2-digit",
    hour12: false,
    timeZone: "UTC",
  });

export default function SortableTask({
  task,
  onToggle,
  onDelete,
}: {
  task: Task;

  onToggle: (
    id: string,
    completed: boolean
  ) => void;

  onDelete: (id: string) => void;
}) {
  const {
    attributes,
    listeners,
    setNodeRef,
    transform,
    transition,
  } = useSortable({
    id: task.id,
    data: {
      status: task.status,
    },
  });

  const style = {
    transform: CSS.Transform.toString(
      transform
    ),
    transition,
  };

  const isOverdue =
    task.dueDate &&
    !task.completed &&
    isPast(new Date(task.dueDate));

  const formattedDueDate = task.dueDate
    ? dueDateFormatter.format(
        new Date(task.dueDate)
      )
    : null;

  return (
    <div
      ref={setNodeRef}
      style={style}
      {...attributes}
      className={`flex items-start justify-between gap-4 rounded-2xl border bg-[var(--surface)] p-4 shadow-sm
      ${
        isOverdue
          ? "border-red-500"
          : "border-[var(--border)]"
      }`}
    >
      <div className="flex min-w-0 flex-1 items-start gap-3">
        <button
          type="button"
          {...listeners}
          className="mt-0.5 shrink-0 cursor-grab rounded p-2 text-zinc-400 transition-colors hover:bg-zinc-100 hover:text-zinc-700 active:cursor-grabbing"
          aria-label={`Drag task ${task.title}`}
        >
          ::
        </button>

        <input
          type="checkbox"
          checked={task.completed}
          className="mt-1 shrink-0"
          onChange={() =>
            onToggle(
              task.id,
              task.completed
            )
          }
        />

        <div className="min-w-0 flex-1">
          <p
            className={
              task.completed
                ? "break-words text-[var(--muted-foreground)] line-through"
                : "break-words text-zinc-900"
            }
          >
            {task.title}
          </p>

          {formattedDueDate && (
            <p className="text-sm text-zinc-500">
              Due: {formattedDueDate}
            </p>
          )}
        </div>
      </div>

      <button
        onClick={() => onDelete(task.id)}
        className="shrink-0 rounded px-3 py-2 text-sm font-medium text-red-600 transition-colors hover:bg-red-50 hover:text-red-700"
      >
        Delete
      </button>
    </div>
  );
}
