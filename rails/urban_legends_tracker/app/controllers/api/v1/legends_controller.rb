class Api::V1::LegendsController < ApplicationController
  def index
    q = Legend.ransack(params[:q])
    @pagy, legends = pagy(q.result, items: 4)

    render json: {
      data: ActiveModelSerializers::SerializableResource.new(legends),
      meta: {
        page: @pagy.page,
        total_pages: @pagy.pages,
        count: @pagy.count
      }
    }
  end

  def show
    legend = Legend.find(params[:id])
    render json: legend
  end
end