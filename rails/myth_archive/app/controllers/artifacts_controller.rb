
class ArtifactsController < ApplicationController
  before_action :set_explorer
  before_action :set_artifact, only: [:show, :edit, :update, :destroy]

  def index
    @q = @explorer.artifacts.ransack(params[:q])

    @pagy, @artifacts = pagy(
      @q.result.order(created_at: :desc),
      items: 6
    )
  end

  def show
  end

  def new
    @artifact = @explorer.artifacts.new
  end

  def create
    @artifact = @explorer.artifacts.new(artifact_params)

    if @artifact.save
      redirect_to [@explorer, @artifact],
                  notice: "Artifact created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @artifact.update(artifact_params)
      redirect_to [@explorer, @artifact],
                  notice: "Artifact updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @artifact.destroy
    redirect_to explorer_artifacts_path(@explorer),
                notice: "Artifact deleted."
  end

  private

  def set_explorer
    @explorer = Explorer.find(params[:explorer_id])
  end

  def set_artifact
    @artifact = @explorer.artifacts.find(params[:id])
  end

  def artifact_params
    params.require(:artifact).permit(
      :name,
      :description,
      :origin_country,
      :danger_level,
      :discovered_on,
      :image
    )
  end
end
