class ChatChannel < ApplicationCable::Channel
  delegate :ability, to: :connection
  protected :ability

  def subscribed
    set_chat
    if authorize?
      stream_from "#{params[:team_id]}_#{params[:type]}_#{@chat.id}"
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)
    @chat.messages << new_message(data["message"])
  end

  private

  def new_message(message_body)
    Message.new(body: message_body, user: current_user)
  end

  def authorize?
    ability.can? :read, @chat
  end

  def set_chat
    @chat = Channel.find(params[:id])
  end
end
