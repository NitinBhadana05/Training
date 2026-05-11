import { prisma } from "@/lib/prisma";
import { getCurrentUser } from "@/lib/get-current-user";
import { NextResponse } from "next/server";
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

export async function PATCH(
  req: Request,
  context: RouteContext<"/api/task/[taskid]">
) {
  try {
    const user = await getCurrentUser();

    if (!user) {
      return NextResponse.json(
        { error: "Unauthorized" },
        { status: 401 }
      );
    }

    const body = await req.json();
    const { taskid } = await context.params;
    const existingTask = await prisma.task.findFirst({
      where: {
        id: taskid,
        userId: user.id,
      },
    });

    if (!existingTask) {
      return NextResponse.json(
        { error: "Task not found" },
        { status: 404 }
      );
    }

    const nextStatus = (
      body.status ?? (
        body.completed ? "DONE" : "TODO"
      )
    ) as TaskStatus;

    await prisma.task.updateMany({
      where: {
        id: taskid,
        userId: user.id,
      },

      data: {
        completed:
          typeof body.completed === "boolean"
            ? body.completed
            : nextStatus === "DONE",
        description: nextStatus,
        position:
          typeof body.position === "number"
            ? body.position
            : existingTask.position,
      },
    });

    const updatedTask = await prisma.task.findFirst({
      where: {
        id: taskid,
        userId: user.id,
      },
    });

    return NextResponse.json(
      serializeTask(updatedTask!)
    );
  } catch (error) {
    return NextResponse.json(
      { error: "Server error" },
      { status: 500 }
    );
  }
}

export async function DELETE(
  req: Request,
  context: RouteContext<"/api/task/[taskid]">
) {
  try {
    const user = await getCurrentUser();

    if (!user) {
      return NextResponse.json(
        { error: "Unauthorized" },
        { status: 401 }
      );
    }

    const { taskid } = await context.params;

    const deletedTask = await prisma.task.deleteMany({
      where: {
        id: taskid,
        userId: user.id,
      },
    });

    if (deletedTask.count === 0) {
      return NextResponse.json(
        { error: "Task not found" },
        { status: 404 }
      );
    }

    return NextResponse.json({
      success: true,
    });
  } catch (error) {
    return NextResponse.json(
      { error: "Server error" },
      { status: 500 }
    );
  }
}
