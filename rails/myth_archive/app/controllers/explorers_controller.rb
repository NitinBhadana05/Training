
class ExplorersController < ApplicationController
  before_action :set_explorer, only: [:show, :edit, :update, :destroy]



def index
  @q = Explorer.ransack(params[:q])

  @pagy, @explorers = pagy(
    @q.result.order(created_at: :desc),
    items: 6
  )
end

  def show
  end

  def new
    @explorer = Explorer.new
  end

  def create
    @explorer = Explorer.new(explorer_params)

    if @explorer.save
      redirect_to @explorer, notice: "Explorer created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @explorer.update(explorer_params)
      redirect_to @explorer, notice: "Explorer updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @explorer.destroy
    redirect_to explorers_path, notice: "Explorer deleted."
  end

  private

  def set_explorer
    @explorer = Explorer.find(params[:id])
  end

  def explorer_params
    params.require(:explorer).permit(:codename, :reputation, :region)
  end
end
