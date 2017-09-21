require 'rails_helper'

RSpec.describe Team, type: :model do

 before do
   @team = FactoryGirl.create(:team)
 end

 it "is valid with valid attributes" do
   expect(@team).to be_valid
 end

 it "is not valid without a slug" do
   @team.slug = nil
   expect(@team).not_to be_valid
 end
 it "is not valid without a user" do
   @team.user = nil
   expect(@team).not_to be_valid
 end
end
