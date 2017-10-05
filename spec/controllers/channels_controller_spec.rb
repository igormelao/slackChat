require 'rails_helper'

describe ChannelsController do
  include Devise::Test::ControllerHelpers

  before(:each) do
    request.env['HTTP_ACCEPT'] = 'application/json'

    @request.env['devise.mapping'] = Devise.mappings[:user]
    @current_user = FactoryGirl.create(:user)
    sign_in @current_user
  end

  describe "POST #create" do
    context "User is Team member" do
      render_views

      before(:each) do
        @team = FactoryGirl.create(:team)
        @team.users << @current_user
        @channel_attributes = FactoryGirl.attributes_for(:channel, team: @team, user: @current_user)

        post :create, params: { channel: @channel_attributes.merge(team_id: @team.id) }
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "returns with valid attributes in BD" do
        expect(Channel.last.slug).to eql(@channel_attributes[:slug])
        expect(Channel.last.user).to eql(@current_user)
        expect(Channel.last.team).to eql(@team)
      end

      it "returns with valid attributes in json" do
        response_hash = JSON.parse(response.body)

        expect(response_hash["slug"]).to eql(@channel_attributes[:slug])
        expect(response_hash["user_id"]).to eql(@current_user.id)
        expect(response_hash["team_id"]).to eql(@team.id)
      end
    end

    context "User isn't Team member" do
      it "returns http forbidden" do
        @team = FactoryGirl.create(:team)
        @channel_attributes = FactoryGirl.attributes_for(:channel, team: @team)
        post :create, params: { channel: @channel_attributes.merge(team_id: @team.id) }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

end
