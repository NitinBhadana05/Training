class ParkingSessionsController < ApplicationController
  
  before_action :set_session, only: [:show, :end_parking]
  
  def index
    @slots = ParkingSlot.where(status: "free").order(:slot_number)
    @active_sessions = ParkingSession.includes(:vehicle, :parking_slot)
                                     .where(status: "active")
                                     .order(entry_time: :desc)
    @completed_sessions = ParkingSession.includes(:vehicle, :parking_slot, :payment)
                                        .where(status: "completed")
                                        .order(exit_time: :desc)
  end
  


  def create
    vehicle = Vehicle.find_or_create_by(vehicle_number: params[:vehicle_number]) do |v|
      v.vehicle_type = "car"
    end

    unless vehicle.persisted?
      respond_to do |format|
        format.html { redirect_to root_path, alert: vehicle.errors.full_messages.to_sentence }
        format.json { render json: { errors: vehicle.errors.full_messages }, status: :unprocessable_entity }
      end
      return
    end

    slot = ParkingSlot.find_by(id: params[:parking_slot_id], status: "free")

    if slot.nil?
      respond_to do |format|
        format.html { redirect_to root_path, alert: "No free slot available" }
        format.json { render json: { error: "No free slot available" }, status: :unprocessable_entity }
      end
      return
    end

    @session = ParkingSession.new(
      vehicle: vehicle,
      parking_slot: slot
    )

    if @session.save
      respond_to do |format|
        format.html { redirect_to root_path, notice: "Parking started" }
        format.json { render json: { message: "Parking started", session: @session }, status: :created }
      end
    else
      respond_to do |format|
        format.html { redirect_to root_path, alert: @session.errors.full_messages.to_sentence }
        format.json { render json: { errors: @session.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end


  def end_parking
    if @session.exit_time.present?
      respond_to do |format|
        format.html { redirect_to root_path, alert: "Session already ended" }
        format.json { render json: { error: "Session already ended" }, status: :unprocessable_entity }
      end
      return
    end

    if @session.update(exit_time: Time.current)
      respond_to do |format|
        format.html { redirect_to payment_path(@session.payment), notice: "Parking ended" }
        format.json do
          render json: {
            message: "Parking ended",
            duration: @session.duration,
            payment: @session.payment
          }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to root_path, alert: @session.errors.full_messages.to_sentence }
        format.json { render json: { errors: @session.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end


  def show
    render json: @session, include: :payment
  end


  def active
    sessions = ParkingSession.where(status: "active")
    render json: sessions
  end

  private

  def set_session
    @session = ParkingSession.find(params[:id])
  end
end
