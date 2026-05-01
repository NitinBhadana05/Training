class ChatChannel < ApplicationCable::Channel
  def subscribed
    def subscribed
      stream_from "chat"
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
