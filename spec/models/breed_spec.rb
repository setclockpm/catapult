require 'rails_helper'

RSpec.describe Breed, type: :model do
  
  it "has a valid factory" do
    expect(FactoryGirl.build(:breed)).to be_valid
  end
  
  describe "A breed record" do
    context "without tags" do
      it "is invalid without a title" do
        breed = Breed.new(title: nil)
        breed.valid?
        expect(breed.errors[:title]).to include("can't be blank")
      end
  
      it "is valid when created with a title" do
        breed = Breed.new(title: "Moon Walk")
        expect(breed).to be_valid
      end
    end
  end
  
  describe "A breed record" do
    context "with tags" do
      it "is valid" do
        breed = FactoryGirl.create(:breed)
        tag1 = breed.tags.create!(title: "Optional")
        tag2 = breed.tags.create!(title: "Zen")
        expect(breed.reload.tags.size).to eq(2)
      end
    end
  end
  
end
