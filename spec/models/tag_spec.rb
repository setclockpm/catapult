require 'rails_helper'

RSpec.describe Tag, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.build(:tag)).to be_valid
  end
end
