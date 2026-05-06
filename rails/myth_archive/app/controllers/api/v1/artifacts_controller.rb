

class Api::V1::ArtifactsController < ApplicationController
  def index
    q = Artifact.ransack(params[:q])

    @pagy, artifacts = pagy(
      q.result.order(created_at: :desc),
      items: 6
    )

    render json: {
      data: ActiveModelSerializers::SerializableResource.new(artifacts),
      meta: {
        page: @pagy.page,
        total_pages: @pagy.pages,
        count: @pagy.count
      }
    }
  end

  def show
    artifact = Artifact.find(params[:id])

    render json: artifact
  end
end
