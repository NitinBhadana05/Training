
class Api::V1::ExplorersController < ApplicationController
  def index
    q = Explorer.ransack(params[:q])

    @pagy, explorers = pagy(
      q.result.order(created_at: :desc),
      items: 6
    )

    render json: {
      data: ActiveModelSerializers::SerializableResource.new(explorers),
      meta: {
        page: @pagy.page,
        total_pages: @pagy.pages,
        count: @pagy.count
      }
    }
  end

  def show
    explorer = Explorer.find(params[:id])

    render json: explorer
  end
end
