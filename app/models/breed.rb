class Breed < ApplicationRecord
  has_many :taggings
  has_many :tags, through: :taggings
  validates :name, presence: true
  
  #accepts_nested_attributes_for :tags
  
  def attributes=(attributes)
    @tag_attributes = attributes.delete(:tags)
    super
  end
  
  def save_tags
    return true if @tag_attributes.blank?
    add_tags
  end
  
  
  private
  
    def add_tags
      tag_records = []
      @tag_attributes.each {|tt| tag_records << Tag.find_or_create_by(name: tt) }
      self.tags << tag_records
    end
  
end