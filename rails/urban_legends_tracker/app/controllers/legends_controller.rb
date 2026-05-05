include Pagy::Backend
class LegendsController < ApplicationController
  before_action :set_legend, only: %i[show edit update destroy]
  before_action :load_legends, only: %i[index destroy]

  def index
    load_legends
  end

  def show
  end

  def new
    @legend = Legend.new
  end

  def create
    @legend = Legend.new(legend_params)

    if @legend.save
      redirect_to legends_path, notice: "Legend created!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @legend.update(legend_params)
      redirect_to legends_path, notice: "Updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @legend.destroy
    load_legends
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("legends_results", partial: "legends/results")
      end
      format.html { redirect_to legends_path, notice: "Deleted!", status: :see_other }
    end
  end

  private

  def load_legends
    @q = Legend.ransack(params[:q])
    legends = @q.result(distinct: true).order(created_at: :desc)
    @pagy, @legends = pagy(legends, limit: 4)
  end

  def set_legend
    @legend = Legend.find(params[:id])
  end

  def legend_params
    params.require(:legend).permit(:title, :description, :location, :credibility_score)
  end
end
