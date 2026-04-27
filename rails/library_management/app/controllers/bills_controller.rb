class BillsController < ApplicationController
  before_action :set_bill, only: %i[show edit update]
  before_action :require_admin!, only: %i[edit update]

  def index
    @bills = Bill.filtered(params)
    @bills = @bills.where(user: current_user) unless admin_user?
    @users = User.ordered if admin_user?
  end

  def show
    return if admin_user? || @bill.user == current_user

    redirect_to bills_path, alert: "You are not authorized to access that bill."
  end

  def edit
  end

  def update
    if @bill.update(bill_params)
      redirect_to @bill, notice: "Bill updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def set_bill
      @bill = Bill.includes(issue: :book, user: []).find(params[:id])
    end

    def bill_params
      params.require(:bill).permit(:status, :notes, :billed_on, :paid_on)
    end
end
