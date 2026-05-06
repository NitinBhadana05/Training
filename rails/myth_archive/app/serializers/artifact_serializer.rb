

class ArtifactSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :description,
             :origin_country,
             :danger_level,
             :discovered_on,
             :image

  belongs_to :explorer

  def image
    return unless object.image.present?

    {
      url: object.image.url,
      thumb: object.image.url(:thumb)
    }
  end
end