require 'rails_helper'

describe ChannelsController do
  include Devise::Test::ControllerHelpers

  before(:each) do
    request.env['HTTP_ACCEPT'] = 'application/json'

    @request.env['devise.mapping'] = Devise.mappings[:user]
    @current_user = FactoryGirl.create(:user)
    sign_in @current_user
  end

  describe "POST :create" do
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

      it "returns with valid association in Team" do
        expect(Team.last.channels.count).to eq(2)
        expect(Team.last.channels[1].slug).to eq(@channel_attributes[:slug])
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

  describe "GET #show" do

    context "User is a Team member" do
      render_views

      before(:each) do
        team = FactoryGirl.create(:team, user: @current_user)
        @channel = FactoryGirl.create(:channel, team: team, user: @current_user)

        @message1 = FactoryGirl.create(:message)
        @message2 = FactoryGirl.create(:message)

        @channel.messages << [@message1, @message2]

        get :show, params: { id: @channel.id }

        @channel_hash = JSON.parse(response.body)
      end

      it "returns http succes" do
        expect(response).to have_http_status(:success)
      end

      it "returns right channel values" do
        expect(@channel_hash["slug"]).to eq(@channel.slug)
        expect(@channel_hash["team_id"]).to eq(@channel.team.id)
        expect(@channel_hash["user_id"]).to eq(@channel.user.id)
      end

      it "returns with the rigth number of messages" do
        expect(@channel_hash["messages"].count).to eql(2)
      end

      it "returns the right messages" do
        expect(@channel_hash["messages"][0]["body"]).to eql(@message1.body)
        expect(@channel_hash["messages"][0]["user_id"]).to eql(@message1.user_id)
        expect(@channel_hash["messages"][1]["body"]).to eql(@message2.body)
        expect(@channel_hash["messages"][1]["user_id"]).to eql(@message2.user_id)
      end
    end

    context "User isn't a Team member" do
      it "return http forbidden" do
        @channel = FactoryGirl.create(:channel)
        get :show, params: { id: @channel.id }

        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "DELETE #destroy" do
    context "User is a Team member" do
      context "User is the channel Owner" do
        before(:each) do
          @team = FactoryGirl.create(:team, user: @current_user)
          @channel = FactoryGirl.create(:channel, team: @team, user: @current_user)
          delete :destroy, params: { id: @channel.id }
        end

        it "return http success" do
          expect(response).to have_http_status(:success)
        end

        it "returns non channel in team" do
          expect(Team.last.channels.count).to eq(1)
          expect(Team.last.channels[0].slug).to eq('general')
        end
      end

      context "User is a team Owner" do
        it "return http success" do
          team = FactoryGirl.create(:team, user: @current_user)
          @channel = FactoryGirl.create(:channel, team: team)
          delete :destroy, params: { id: @channel.id }
          expect(response).to have_http_status(:success)
        end
      end

      context "User isn't the channel Owner" do
        it "return http forbidden" do
          @channel = FactoryGirl.create(:channel)
          delete :destroy, params: { id: @channel.id }
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context "User isn't a team member" do
      it "returns http forbidden" do
        team = FactoryGirl.create(:team)
        @channel = FactoryGirl.create(:channel, team: team)
        delete :destroy, params: { id: @channel.id }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
