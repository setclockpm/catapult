class Tag < ApplicationRecord
  has_many :taggings, dependent: :delete_all
  has_many :breeds, through: :taggings
  
  validates :name, presence: true
  
  
  
  def destroy_if_no_breed_associated
    self.destroy if breeds.count == 0
  end
  
end
