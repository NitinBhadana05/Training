class ParkingSessionsController < ApplicationController
  def index
    @slots = ParkingSlot.where(status: "free")
    @active_sessions = ParkingSession.where(status: "active")
  end
end
