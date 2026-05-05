class LegendSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :location,
             :credibility_score, :created_at, :updated_at,
             :cover_image

  def cover_image
    return unless object.cover_image.present?

    {
      url: object.cover_image.url,
      thumb: {
        url: object.cover_image.url(:thumb)
      }
    }
  end
end