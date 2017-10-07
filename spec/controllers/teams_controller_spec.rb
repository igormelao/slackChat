require 'rails_helper'

describe TeamsController do
  include Devise::Test::ControllerHelpers

  before(:each)do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    @current_user = FactoryGirl.create(:user)
    sign_in @current_user
  end

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do

    context "team exists" do

      context "User is the owner of the team" do
        it "returns success" do
          team = FactoryGirl.create(:team, user: @current_user)
          get :show, params: { slug: team.slug }
          expect(response).to have_http_status(:success)
        end
      end

      context "user is not the owner or member of the team" do
        it "redirects to root" do
          team = FactoryGirl.create(:team, user: FactoryGirl.create(:user))
          get :show, params: { slug: team.slug }
          expect(response).to redirect_to('/')
        end
      end

      context "team don't exists" do
        it "redirects to root" do
          team_attributes = FactoryGirl.attributes_for(:team)
          get :show, params: { slug: team_attributes[:slug] }
          expect(response).to redirect_to('/')
        end
      end
    end
  end

  describe "POST #create" do
    context "create team successfully" do
      before(:each) do
        @team_attributes = FactoryGirl.attributes_for(:team, user: @current_user)
        post :create, params: { team: @team_attributes }
      end

      it "redirects to new team" do
        expect(response).to have_http_status(302)
        expect(response).to redirect_to("/#{@team_attributes[:slug]}")
      end

      it "with rights attributes" do
        expect(Team.last.user_id).to eql(@current_user.id)
        expect(Team.last.slug).to eql(@team_attributes[:slug])
      end

      it "with general channel created" do
        expect(Team.last.channels.count).to eq(1)
        expect(Team.last.channels[0].slug).to eq("general")
      end
    end

    context "create team with errors" do
      it "redirect to root with errors" do
        @team_attributes = FactoryGirl.attributes_for(:team, slug: nil)
        post :create, params: { team: @team_attributes }
        expect(response).to redirect_to('/')
      end
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      request.env["HTTP_ACCEPT"] = 'application/json'
    end

    context "User is the Team owner" do
      it "return http success" do
        team = FactoryGirl.create(:team, user: @current_user)
        delete :destroy, params: { id: team.id }
        expect(response).to have_http_status(:success)
      end

      it "delete the rigth team" do
        team = FactoryGirl.create(:team, user: @current_user)
        delete :destroy, params: { id: team.id }
        expect(Team.all.count).to eq(0)
      end
    end

    context "User isn't the Team owner" do
      it "returns http forbidden" do
        team = FactoryGirl.create(:team)
        delete :destroy, params: { id: team.id }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
