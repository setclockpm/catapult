class Tag < ApplicationRecord
  has_many :taggings
  has_many :breeds, through: :taggings
  
  validates :name, presence: true
  
  
  def self.filtered(query)
    where("name LIKE :q", { q: "%#{query}%"})
  end
  
  
end
