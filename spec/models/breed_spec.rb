require 'rails_helper'

RSpec.describe Breed, type: :model do
  
  it "has a valid factory" do
    expect(FactoryGirl.build(:breed)).to be_valid
  end
  
  describe "A breed record" do
    context "without tags" do
      it "is invalid without a name" do
        breed = Breed.new(name: nil)
        breed.valid?
        expect(breed.errors[:name]).to include("can't be blank")
      end
  
      it "is valid when created with a name" do
        breed = Breed.new(name: "Scottish Fold")
        expect(breed).to be_valid
      end
    end
  end
  
  describe "A breed record" do
    context "with tags" do
      it "is valid" do
        breed = FactoryGirl.create(:breed)
        tag1 = breed.tags.create!(name: "Intelligent")
        tag2 = breed.tags.create!(name: "Zen")
        expect(breed.reload.tags.size).to eq(2)
      end
    end
  end
  
end
