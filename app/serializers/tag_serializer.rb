class TagSerializer < ActiveModel::Serializer
  attributes :id, :name
  attribute :breed_count, if: :stats_wanted?
  attribute :breed_ids, if: :stats_wanted?
  has_many :breeds
  
  
  def stats_wanted?
    instance_options[:stats]
  end
  
  def breed_ids
    object.breeds.pluck(:id)
  end
  
  def breed_count
    breed_ids.size
  end
end
