class Breed < ApplicationRecord
  # attr_accessor :stats_wanted
 #  attr_reader :tag_count, :tag_ids
  # This is to trigger the callback in tagagings :)
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  validates :name, presence: true, uniqueness: true
  
  
  def attributes=(attributes)
    attributes.delete(:id)
    attributes || {}
    @tag_attributes = attributes.delete(:tags)
    super
  end
  
  def add_tags
    @tag_attributes.blank? || build_tags
  end
  
  
  def update_tags
    @tag_attributes.nil? || replace_tags
  end
  
  
  
  private
    def build_tags
      # Associating new tags to breed by finding them if they exist or creating them if they don't
      tag_records = []
      
      # Could drill into this more to force an explicit false here
      # in case there was a problem creating a tag record
      # but .... time permitting
      @tag_attributes.each {|tt| tag_records << Tag.find_or_create_by(name: tt) }
      self.tags << tag_records
    end
    
    # Since we're NOT merging:
    # It is less complex to delete all in one fell swoop then recreate each tag
    def replace_tags
      self.tags.delete_all
      
      # We received empry array => remove all tags
      return true if @tag_attributes.empty?
      build_tags
    end
  
end