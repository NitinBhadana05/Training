class IssuesController < ApplicationController
  before_action :set_issue, only: %i[show edit update destroy mark_returned]
  before_action :require_admin!, only: %i[new create edit update destroy]

  def index
    @issues = Issue.filtered(params)
    @issues = @issues.where(user: current_user) unless admin_user?
    load_filters if admin_user?
  end

  def show
    return if admin_user? || @issue.user == current_user

    redirect_to issues_path, alert: "You are not authorized to access that issue."
  end

  def new
    @issue = Issue.new(issue_date: Date.current, due_date: Date.current + Book::STANDARD_RENTAL_DAYS.days, transaction_type: :rent)
    load_form_dependencies
  end

  def create
    load_form_dependencies
    @issue = Issue.new(issue_create_params)

    created = Issue.transaction do
      @issue.valid? && reserve_inventory_for_create(@issue) && @issue.save
    end

    if created
      redirect_to issue_path(@issue), notice: "Issue record created successfully."
    else
      restore_reserved_inventory(@issue) if @issue.book&.persisted? && @issue.new_record?
      flash.now[:alert] ||= "Unable to create the issue record."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    load_form_dependencies
  end

  def update
    load_form_dependencies
    prior_return_state = @issue.returned?

    if @issue.update(issue_update_params)
      reconcile_return_inventory!(prior_return_state)
      redirect_to @issue, notice: "Issue record updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    restore_inventory_if_needed!(@issue)
    @issue.destroy
    redirect_to issues_path, notice: "Issue record deleted successfully.", status: :see_other
  end

  def mark_returned
    unless @issue.returnable_by?(current_user)
      redirect_to issues_path, alert: "You are not authorized to return that issue."
      return
    end

    @issue.mark_as_returned!
    redirect_to @issue, notice: "Book marked as returned."
  end

  private
    def set_issue
      @issue = Issue.includes(:user, :book, :bill).find(params[:id])
    end

    def issue_create_params
      params.require(:issue).permit(:user_id, :book_id, :transaction_type, :issue_date, :due_date)
    end

    def issue_update_params
      params.require(:issue).permit(:due_date, :return_date, :status)
    end

    def load_form_dependencies
      @users = User.ordered
      @books = Book.ordered
    end

    def load_filters
      @users = User.ordered
      @books = Book.ordered
    end

    def reserve_inventory_for_create(issue)
      issue.book.with_lock do
        unless issue.book.available_for_checkout?
          issue.errors.add(:base, "Selected book is unavailable")
          return false
        end

        issue.book.available_copies -= 1
        issue.book.total_copies -= 1 if issue.purchase?
        issue.book.save!
      end

      true
    end

    def reconcile_return_inventory!(prior_return_state)
      return unless @issue.rent?

      if !prior_return_state && @issue.returned?
        @issue.book.increment!(:available_copies)
      elsif prior_return_state && !@issue.returned?
        @issue.book.decrement!(:available_copies)
      end
    end

    def restore_reserved_inventory(issue)
      issue.book.with_lock do
        issue.book.increment!(:available_copies)
        issue.book.increment!(:total_copies) if issue.purchase?
      end
    end

    def restore_inventory_if_needed!(issue)
      issue.book.with_lock do
        if issue.purchase?
          issue.book.increment!(:total_copies)
          issue.book.increment!(:available_copies)
        elsif !issue.returned?
          issue.book.increment!(:available_copies)
        end
      end
    end
end
