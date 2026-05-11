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

export async function POST(req: Request) {
  try {
    const user = await getCurrentUser();

    if (!user) {
      return NextResponse.json(
        { error: "Unauthorized" },
        { status: 401 }
      );
    }

    const body = await req.json();

    const {
      title,
      dueDate,
      status,
    } = body as {
      title?: string;
      dueDate?: string | null;
      status?: TaskStatus;
    };

    if (!title) {
      return NextResponse.json(
        { error: "Title required" },
        { status: 400 }
      );
    }

    const taskCount = await prisma.task.count({
      where: {
        userId: user.id,
      },
    });

    const task = await prisma.task.create({
      data: {
        title,
        dueDate: dueDate
          ? new Date(dueDate)
          : null,
        userId: user.id,
        position: taskCount + 1,
        description: status ?? "TODO",
        completed: status === "DONE",
      },
    });

    return NextResponse.json(serializeTask(task));
  } catch (error) {
    return NextResponse.json(
      { error: "Server error" },
      { status: 500 }
    );
  }
}

export async function GET() {
  try {
    const user = await getCurrentUser();

    if (!user) {
      return NextResponse.json(
        { error: "Unauthorized" },
        { status: 401 }
      );
    }

    const tasks = await prisma.task.findMany({
      where: {
        userId: user.id,
      },

      orderBy: {
        position: "asc",
      },
    });

    return NextResponse.json(
      tasks.map(serializeTask)
    );
  } catch (error) {
    return NextResponse.json(
      { error: "Server error" },
      { status: 500 }
    );
  }
}

export async function PATCH(req: Request) {
  try {
    const user = await getCurrentUser();

    if (!user) {
      return NextResponse.json(
        { error: "Unauthorized" },
        { status: 401 }
      );
    }

    const body = await req.json();
    const { tasks } = body as {
      tasks?: Array<{
        id: string;
        position: number;
        status: TaskStatus;
      }>;
    };

    if (!Array.isArray(tasks)) {
      return NextResponse.json(
        { error: "Tasks array required" },
        { status: 400 }
      );
    }

    await Promise.all(
      tasks.map((task) =>
        prisma.task.updateMany({
          where: {
            id: task.id,
            userId: user.id,
          },
          data: {
            position: task.position,
            description: task.status,
            completed: task.status === "DONE",
          },
        })
      )
    );

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
