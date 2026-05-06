

class ExplorerSerializer < ActiveModel::Serializer
  attributes :id,
             :codename,
             :reputation,
             :region,
             :created_at,
             :artifacts_count

  def artifacts_count
    object.artifacts.size
  end
end
