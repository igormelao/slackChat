require 'rails_helper'

RSpec.describe Talk, type: :model do
  before(:each) do
    @talk = FactoryGirl.create(:talk)
  end

  context "be valid" do
    it " be valid " do
      expect(@talk).to be_valid
    end
  end

  context  "not be valid" do
    it " without user one" do
      @talk.user_one = nil
      expect(@talk).not_to be_valid
    end

    it "without user two" do
      @talk.user_two = nil
      expect(@talk).not_to be_valid
    end

    it "without team" do
      @talk.team = nil
      expect(@talk).not_to be_valid
    end
  end
end
