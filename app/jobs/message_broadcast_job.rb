class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    m = message.messagable
    chat_name = "#{m.team.id}_channels_#{m.id}"
    ActionCable.server.broadcast(chat_name, {
                                          message: message.body,
                                          date: message.created_at.strftime("%d/%m/%y"),
                                          name: message.user.name
                                        })
  end
end
