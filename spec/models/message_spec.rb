require 'rails_helper'

RSpec.describe Message, type: :model do
  before(:each) do
    @message = FactoryGirl.create(:message)
  end

  it 'is valid object' do
    expect(@message).to be_valid
  end

  it 'is not valid object without a body' do
    @message.body = nil
    expect(@message).not_to be_valid
  end

  it 'is not valid object without a user' do
    @message.user = nil
    expect(@message).not_to be_valid
  end

  it 'is not valid object without a association polymorphic with channel' do
    @message.messagable = nil
    expect(@message).not_to be_valid
  end
end
