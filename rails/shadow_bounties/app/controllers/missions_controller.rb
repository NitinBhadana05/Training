

class MissionsController < ApplicationController
  before_action :set_mission, only: [:show, :edit, :update, :destroy]

  def index
    @missions = Mission.includes(:hunter, :bounty)
  end

  def show
  end

  def new
    @mission = Mission.new
  end

  def create
    @mission = Mission.new(mission_params)

    if @mission.save
      redirect_to @mission, notice: "Mission created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @mission.update(mission_params)
      redirect_to @mission, notice: "Mission updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @mission.destroy
    redirect_to missions_path, notice: "Mission deleted."
  end

  private

  def set_mission
    @mission = Mission.find(params[:id])
  end

  def mission_params
    params.require(:mission).permit(
      :hunter_id,
      :bounty_id,
      :completed,
      :notes
    )
  end
end