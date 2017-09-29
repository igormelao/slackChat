require 'rails_helper'

describe TeamUsersController do
  include Devise::Test::ControllerHelpers

  before(:each) do
    request.env["HTTP_ACCEPT"] = 'application/json'
    @request.env['devise.mapping'] = Devise.mappings[:user]
    @current_user = FactoryGirl.create(:user)
    sign_in @current_user
  end

  describe "#POST create" do
    context "Team owner" do
      before(:each) do
        @team = FactoryGirl.create(:team, user: @current_user)
        @guest_user = FactoryGirl.create(:user)
        post :create, params: { team_user: { user_id: @guest_user.id, team_id: @team.id } }
      end

      it "return http success" do
        expect(response).to have_http_status(:success)
      end

      it "with valid params" do
        expect(TeamUser.last.user_id).to eq(@guest_user.id)
        expect(TeamUser.last.team_id).to eq(@team.id)
      end

      it "with invalid user_id param" do
        post :create, params: { team_user: { team_id: @team.id } }
        expect(response).to have_http_status(422)
      end
    end

    context "Team not owner" do
      it "returns http forbidden" do
        @team = FactoryGirl.create(:team)
        @guest_user = FactoryGirl.create(:user)
        post :create, params: { team_user: { user_id: @guest_user.id, team_id: @team.id } }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "DELETE #destroy" do
    context "Team Owner" do
      it "returns http success" do
        @team = FactoryGirl.create(:team, user_id: @current_user.id)
        @guest_user = FactoryGirl.create(:user)
        @team.users << @guest_user
        delete :destroy, params: { user_id: @guest_user.id, team_id: @team.id  }
        expect(response).to have_http_status(:success)
      end
    end
    context "Team not Owner" do
      it "return http forbidden" do
        @team = FactoryGirl.create(:team)
        @guest_user = FactoryGirl.create(:user)
        @team_user = FactoryGirl.create(:team_user, team_id: @team.id, user_id: @guest_user.id)
        delete :destroy, params: { user_id: @guest_user.id, team_id: @team.id }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
