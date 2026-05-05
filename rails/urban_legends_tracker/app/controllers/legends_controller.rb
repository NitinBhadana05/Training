include Pagy::Backend
class LegendsController < ApplicationController
  before_action :set_legend, only: %i[show edit update destroy]

  def index
    @pagy, @legends = pagy(Legend.order(created_at: :desc), limit: 4)
  end

  def show
  end

  def new
    @legend = Legend.new
  end

  def create
    @legend = Legend.new(legend_params)

    if @legend.save
      redirect_to @legend, notice: "Legend created!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @legend.update(legend_params)
      redirect_to @legend, notice: "Updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @legend.destroy
    redirect_to legends_path, notice: "Deleted!", status: :see_other
  end

  private

  def set_legend
    @legend = Legend.find(params[:id])
  end

  def legend_params
    params.require(:legend).permit(:title, :description, :location, :credibility_score)
  end
end
