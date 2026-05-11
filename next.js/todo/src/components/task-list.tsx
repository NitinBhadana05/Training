"use client";

import {
  closestCenter,
  DndContext,
  type DragEndEvent,
  type DragOverEvent,
} from "@dnd-kit/core";
import {
  arrayMove,
} from "@dnd-kit/sortable";
import { useEffect } from "react";
import {
  useTaskStore,
} from "@/store/task-store";
import type {
  Task,
  TaskStatus,
} from "@/types/task";
import KanbanColumn from "./kanban-column";
import TaskForm from "./task-form";

const columns: Array<{
  status: TaskStatus;
  title: string;
  description: string;
}> = [
  {
    status: "TODO",
    title: "To Do",
    description: "New work waiting to be picked up",
  },
  {
    status: "IN_PROGRESS",
    title: "In Progress",
    description: "Tasks currently being worked on",
  },
  {
    status: "DONE",
    title: "Done",
    description: "Completed work",
  },
];

function groupTasksByStatus(
  tasks: Task[]
) {
  return {
    TODO: tasks.filter(
      (task) => task.status === "TODO"
    ),
    IN_PROGRESS: tasks.filter(
      (task) => task.status === "IN_PROGRESS"
    ),
    DONE: tasks.filter(
      (task) => task.status === "DONE"
    ),
  };
}

function reindexTasks(tasks: Task[]) {
  return tasks.map((task, index) => ({
    ...task,
    position: index + 1,
  }));
}

function normalizeTaskBoard(
  tasks: Task[]
) {
  const groups = groupTasksByStatus(tasks);

  return [
    ...reindexTasks(groups.TODO),
    ...reindexTasks(groups.IN_PROGRESS),
    ...reindexTasks(groups.DONE),
  ];
}

export default function TaskList({
  initialTasks,
}: {
  initialTasks: Task[];
}) {
  const {
    tasks,
    initialized,
    initializeTasks,
    setTasks,
    addTask,
    updateTask,
    deleteTask,
  } = useTaskStore();

  useEffect(() => {
    initializeTasks(
      normalizeTaskBoard(initialTasks)
    );
  }, [initialTasks, initializeTasks]);

  const boardTasks =
    initialized
      ? normalizeTaskBoard(tasks)
      : normalizeTaskBoard(initialTasks);

  const groupedTasks =
    groupTasksByStatus(boardTasks);

  const syncTasks = async (
    nextTasks: Task[]
  ) => {
    const previousTasks = boardTasks;
    const normalizedTasks =
      normalizeTaskBoard(nextTasks);

    setTasks(normalizedTasks);

    const res = await fetch("/api/task", {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        tasks: normalizedTasks.map((task) => ({
          id: task.id,
          position: task.position,
          status: task.status,
        })),
      }),
    });

    if (!res.ok) {
      setTasks(previousTasks);
    }
  };

  const handleTaskCreated = (
    task: Task
  ) => {
    addTask(task);
  };

  const handleToggle = async (
    id: string,
    completed: boolean
  ) => {
    const existingTask = boardTasks.find(
      (task) => task.id === id
    );

    if (!existingTask) {
      return;
    }

    const nextTask: Task = {
      ...existingTask,
      completed: !completed,
      status: completed ? "TODO" : "DONE",
    };

    updateTask(nextTask);

    const res = await fetch(`/api/task/${id}`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        completed: nextTask.completed,
        status: nextTask.status,
      }),
    });

    if (!res.ok) {
      updateTask(existingTask);
    }
  };

  const handleDelete = async (
    id: string
  ) => {
    const previousTasks = boardTasks;
    deleteTask(id);

    const res = await fetch(`/api/task/${id}`, {
      method: "DELETE",
    });

    if (!res.ok) {
      setTasks(previousTasks);
    }
  };

  const moveTaskLocally = (
    activeId: string,
    overId: string
  ) => {
    const activeTask = boardTasks.find(
      (task) => task.id === activeId
    );

    if (!activeTask) {
      return boardTasks;
    }

    const overTask = boardTasks.find(
      (task) => task.id === overId
    );
    const overStatus =
      overTask?.status ??
      (overId as TaskStatus);

    const sourceTasks = groupedTasks[
      activeTask.status
    ].filter((task) => task.id !== activeId);

    if (
      overTask &&
      activeTask.status === overTask.status
    ) {
      const sameColumnTasks = groupedTasks[
        activeTask.status
      ];
      const oldIndex =
        sameColumnTasks.findIndex(
          (task) => task.id === activeId
        );
      const newIndex =
        sameColumnTasks.findIndex(
          (task) => task.id === overTask.id
        );

      if (
        oldIndex === -1 ||
        newIndex === -1
      ) {
        return boardTasks;
      }

      const reorderedColumn = reindexTasks(
        arrayMove(
          sameColumnTasks,
          oldIndex,
          newIndex
        )
      );

      const nextGroups = {
        ...groupedTasks,
        [activeTask.status]:
          reorderedColumn,
      };

      return normalizeTaskBoard([
        ...nextGroups.TODO,
        ...nextGroups.IN_PROGRESS,
        ...nextGroups.DONE,
      ]);
    }

    const destinationTasks =
      activeTask.status === overStatus
        ? sourceTasks
        : [
            ...groupedTasks[overStatus].filter(
              (task) => task.id !== activeId
            ),
          ];

    const insertionIndex =
      overTask && overTask.status === overStatus
        ? destinationTasks.findIndex(
            (task) => task.id === overTask.id
          )
        : destinationTasks.length;

    const movedTask: Task = {
      ...activeTask,
      status: overStatus,
      completed: overStatus === "DONE",
    };

    destinationTasks.splice(
      insertionIndex < 0
        ? destinationTasks.length
        : insertionIndex,
      0,
      movedTask
    );

    const nextGroups = {
      ...groupedTasks,
      [activeTask.status]:
        activeTask.status === overStatus
          ? destinationTasks
          : sourceTasks,
      [overStatus]: destinationTasks,
    };

    return normalizeTaskBoard([
      ...nextGroups.TODO,
      ...nextGroups.IN_PROGRESS,
      ...nextGroups.DONE,
    ]);
  };

  const handleDragOver = (
    event: DragOverEvent
  ) => {
    const { active, over } = event;

    if (!over || active.id === over.id) {
      return;
    }

    const nextTasks = moveTaskLocally(
      String(active.id),
      String(over.id)
    );

    if (nextTasks !== boardTasks) {
      setTasks(nextTasks);
    }
  };

  const handleDragEnd = async (
    event: DragEndEvent
  ) => {
    const { active, over } = event;

    if (!over || active.id === over.id) {
      return;
    }

    const nextTasks = moveTaskLocally(
      String(active.id),
      String(over.id)
    );

    if (nextTasks !== boardTasks) {
      await syncTasks(nextTasks);
    }
  };

  return (
    <div className="space-y-6">
      <TaskForm
        onTaskCreated={handleTaskCreated}
      />

      <DndContext
        collisionDetection={closestCenter}
        onDragOver={handleDragOver}
        onDragEnd={handleDragEnd}
      >
        <div className="grid gap-6 xl:grid-cols-3">
          {columns.map((column) => (
            <KanbanColumn
              key={column.status}
              status={column.status}
              title={column.title}
              description={column.description}
              tasks={groupedTasks[column.status]}
              onToggle={handleToggle}
              onDelete={handleDelete}
            />
          ))}
        </div>
      </DndContext>
    </div>
  );
}
