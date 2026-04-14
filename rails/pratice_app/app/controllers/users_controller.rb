
class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def tasks
    @task_message = "This is task page"
    @task = Task.new
    @tasks = Task.order(created_at: :desc)
  end

  def create_task
    @task = Task.new(task_params)

    if @task.save
      redirect_to "/tasks"
    else
      @task_message = "this is task page"
      @tasks = Task.order(created_at: :desc)
      render :tasks, status: :unprocessable_entity
    end
  end

  def destroy_task
    @task = Task.find_by(id: params[:id])
    @task&.destroy
    redirect_to "/tasks"
  end


  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to "/users"
    else
      render :new
    end
  end

  def show
    @user = User.find_by(id: params[:id])
  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find_by(id: params[:id])

    if @user.update(user_params)
      redirect_to "/users/#{@user.id}"
    else
      render :edit
    end
  end

  def destroy
    @user = User.find_by(id: params[:id])
    @user.destroy
    redirect_to "/users"
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :phone)
  end

  def task_params
    params.require(:task).permit(:title, :status)
  end











end
