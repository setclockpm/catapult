class Tagging < ApplicationRecord
  belongs_to :tag
  belongs_to :breed
  after_destroy :check_unused_tags
  
  
  private
    def check_unused_tags
      puts "checking unused tags"
      tag.destroy_if_no_breed_associated
    end
  
  
end
