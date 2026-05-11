import { create } from "zustand";
import type { Task } from "@/types/task";

type TaskStore = {
  tasks: Task[];
  initialized: boolean;
  initializeTasks: (tasks: Task[]) => void;
  setTasks: (tasks: Task[]) => void;
  addTask: (task: Task) => void;
  updateTask: (task: Task) => void;
  deleteTask: (id: string) => void;
};

export const useTaskStore = create<TaskStore>(
  (set) => ({
    tasks: [],
    initialized: false,

    initializeTasks: (tasks) =>
      set((state) =>
        state.initialized
          ? state
          : {
              tasks,
              initialized: true,
            }
      ),

    setTasks: (tasks) =>
      set({
        tasks,
        initialized: true,
      }),

    addTask: (task) =>
      set((state) => ({
        tasks: [...state.tasks, task],
      })),

    updateTask: (task) =>
      set((state) => ({
        tasks: state.tasks.map((currentTask) =>
          currentTask.id === task.id
            ? {
                ...currentTask,
                ...task,
              }
            : currentTask
        ),
      })),

    deleteTask: (id) =>
      set((state) => ({
        tasks: state.tasks.filter(
          (task) => task.id !== id
        ),
      })),
  })
);
