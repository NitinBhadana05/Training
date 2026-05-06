

class BountiesController < ApplicationController
  before_action :set_bounty, only: [:show, :edit, :update, :destroy]

  def index
    @q = Bounty.ransack(params[:q])

    @pagy, @bounties = pagy(
      @q.result.order(created_at: :desc),
      items: 5
    )
  end

  def show
  end

  def new
    @bounty = Bounty.new
  end

  def create
    @bounty = Bounty.new(bounty_params)

    if @bounty.save
      redirect_to @bounty, notice: "Bounty created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @bounty.update(bounty_params)
      redirect_to @bounty, notice: "Bounty updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @bounty.destroy
    redirect_to bounties_path, notice: "Bounty deleted."
  end

  private

  def set_bounty
    @bounty = Bounty.find(params[:id])
  end

  def bounty_params
    params.require(:bounty).permit(
      :target_name,
      :threat_level,
      :last_seen,
      :reward_amount,
      :status,
      :poster_image
    )
  end
end