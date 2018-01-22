class BreedSerializer < ActiveModel::Serializer
  attributes :id, :name, :tag_ids, :tag_count
  attribute :tag_count, if: :stats_wanted?
  attribute :tag_ids, if: :stats_wanted?
  has_many :tags
  
  def stats_wanted?
    instance_options[:stats]
  end
 
  def tag_ids
    object.tags.pluck(:id)
  end
  
  def tag_count
    tag_ids.size
  end
  
end
