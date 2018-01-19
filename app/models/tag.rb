class Tag < ApplicationRecord
  has_many :taggings
  has_many :breeds, through: :taggings
  
  validates :title, presence: true
  
  
  def self.filtered(query)
    where("title LIKE :q", { q: "%#{query}%"})
  end
  
  
end
