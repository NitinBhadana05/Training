

class HuntersController < ApplicationController
  before_action :set_hunter, only: [:show, :edit, :update, :destroy]

  def index
    @q = Hunter.ransack(params[:q])

    @pagy, @hunters = pagy(
      @q.result.order(created_at: :desc),
      items: 5
    )
  end

  def show
  end

  def new
    @hunter = Hunter.new
  end

  def create
    @hunter = Hunter.new(hunter_params)

    if @hunter.save
      redirect_to @hunter, notice: "Hunter created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @hunter.update(hunter_params)
      redirect_to @hunter, notice: "Hunter updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @hunter.destroy
    redirect_to hunters_path, notice: "Hunter deleted."
  end

  private

  def set_hunter
    @hunter = Hunter.find(params[:id])
  end

  def hunter_params
    params.require(:hunter).permit(:alias, :rank, :region)
  end
end