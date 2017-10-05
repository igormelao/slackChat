require 'rails_helper'

RSpec.describe Channel, type: :model do

  before(:each) do
    @channel = FactoryGirl.create(:channel)
  end
  it "is valid object" do
    expect(@channel).to be_valid
  end

  it "is not valid object without a slug" do
    @channel.slug = nil
    expect(@channel).not_to be_valid
  end

  it "is not valid object without a user" do
    @channel.user = nil
    expect(@channel).not_to be_valid
  end

  it "is not valid object without a team" do
    @channel.team = nil
    expect(@channel).not_to be_valid
  end

end
