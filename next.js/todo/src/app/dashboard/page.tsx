import { getCurrentUser } from "@/lib/get-current-user";
import { prisma } from "@/lib/prisma";
import LogoutButton from "@/components/logout-button";
import TaskList from "@/components/task-list";
import type {
  Task,
  TaskStatus,
} from "@/types/task";

function normalizeTaskStatus(
  rawStatus: string | null | undefined,
  completed: boolean
): TaskStatus {
  if (
    rawStatus === "TODO" ||
    rawStatus === "IN_PROGRESS" ||
    rawStatus === "DONE"
  ) {
    return rawStatus;
  }

  return completed ? "DONE" : "TODO";
}

function serializeTask(task: {
  id: string;
  title: string;
  completed: boolean;
  position: number;
  dueDate: Date | null;
  description: string | null;
}): Task {
  return {
    id: task.id,
    title: task.title,
    completed: task.completed,
    position: task.position,
    dueDate: task.dueDate?.toISOString() ?? null,
    status: normalizeTaskStatus(
      task.description,
      task.completed
    ),
  };
}

export default async function DashboardPage() {
  const user = await getCurrentUser();
  const displayName = user?.name?.trim() || user?.email || "User";

  const initialTasks = user
    ? (
        await prisma.task.findMany({
        where: {
          userId: user.id,
        },
        orderBy: {
          position: "asc",
        },
      })
      ).map(serializeTask)
    : [];

  return (
    <main className="mx-auto min-h-screen max-w-[1600px] px-6 py-10">
      <div className="mb-8 rounded-3xl border border-[var(--border)] bg-[var(--surface)] p-8 shadow-sm">
        <div className="flex flex-col gap-4 sm:flex-row sm:items-start sm:justify-between">
          <div>
            <p className="text-sm font-semibold uppercase tracking-[0.2em] text-[var(--accent)]">
              Dashboard
            </p>
            <h1 className="mt-3 text-4xl font-bold text-zinc-950">
              Todo Dashboard
            </h1>
            <p className="mt-3 text-base text-[var(--muted-foreground)]">
              Welcome, <span className="font-semibold text-zinc-900">{displayName}</span>
            </p>
          </div>

          <LogoutButton />
        </div>
      </div>

      <TaskList initialTasks={initialTasks} />
    </main>
  );
}
