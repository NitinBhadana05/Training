class PaymentsController < ApplicationController
  before_action :set_payment, only: [:show, :pay]

  # 📄 Show Payment
  def show
    respond_to do |format|
      format.html
      format.json { render json: @payment }
    end
  end

  # 💳 Mark as Paid
  def pay
    if @payment.payment_status == "paid"
      respond_to do |format|
        format.html { redirect_to root_path, alert: "Already paid" }
        format.json { render json: { message: "Already paid" } }
      end
      return
    end

    if @payment.update(
      payment_status: "paid",
      paid_at: Time.current
    )
      respond_to do |format|
        format.html { redirect_to payment_path(@payment), notice: "Payment successful" }
        format.json { render json: { message: "Payment successful", payment: @payment } }
      end
    else
      respond_to do |format|
        format.html { redirect_to root_path, alert: @payment.errors.full_messages.to_sentence }
        format.json { render json: { errors: @payment.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_payment
    @payment = Payment.find(params[:id])
  end
end
