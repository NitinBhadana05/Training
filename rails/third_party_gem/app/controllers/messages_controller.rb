class MessagesController < ApplicationController
  def create
    ActionCable.server.broadcast("chat", { message: params[:message] })
    head :ok
  end
end