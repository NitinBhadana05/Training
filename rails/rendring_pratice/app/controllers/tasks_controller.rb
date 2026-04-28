class TasksController < ApplicationController
  before_action :load_pending_tasks, only: [:index]

  def index
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      redirect_to @task
    else
      render :new
    end
  end

  private

  def load_pending_tasks
    @tasks = Task.where(status: "pending")
  end

  def task_params
    params.require(:task).permit(:title)
  end
end
