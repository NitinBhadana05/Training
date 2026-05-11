export type TaskStatus =
  | "TODO"
  | "IN_PROGRESS"
  | "DONE";

export type Task = {
  id: string;
  title: string;
  completed: boolean;
  position: number;
  dueDate?: string | null;
  status: TaskStatus;
};
