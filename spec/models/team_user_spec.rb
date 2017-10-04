require 'rails_helper'

RSpec.describe TeamUser, type: :model do
  it "should be a valid "do
    @team_user = FactoryGirl.create(:team_user)
    expect(@team_user).to be_valid
  end

  it "should not be a valid without a user" do
    @team_user = FactoryGirl.create(:team_user)
    @team_user.user = nil
    expect(@team_user).not_to be_valid
  end

  it "should not be a valid without a team" do
    @team_user = FactoryGirl.create(:team_user)
    @team_user.team = nil
    expect(@team_user).not_to be_valid
  end
end
