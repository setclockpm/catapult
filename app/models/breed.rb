class Breed < ApplicationRecord
  has_many :taggings, dependent: :delete_all
  has_many :tags, through: :taggings
  validates :name, presence: true, uniqueness: true
  
  #accepts_nested_attributes_for :tags
  
  def attributes=(attributes)
    @tag_attributes = attributes.delete(:tags)
    super
  end
  
  def save_tags
    return true if @tag_attributes.blank?
    add_tags
  end
  
  def replace_tags
    return @tag_attributes.nil? || replace_tags
  end
  
  
  
  private
  
    def add_tags
      tag_records = []
      @tag_attributes.each {|tt| tag_records << Tag.find_or_create_by(name: tt) }
      self.tags << tag_records
    end
  
end