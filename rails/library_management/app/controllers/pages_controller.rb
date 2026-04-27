class PagesController < ApplicationController
  def home
    @book_count = Book.count
    @available_books_count = Book.active.where("available_copies > 0").count
    @active_issue_count = Issue.where(status: [Issue.statuses[:active], Issue.statuses[:overdue]]).count
    @overdue_issue_count = Issue.overdue.count
    @pending_bill_total = Bill.pending.sum(:total_amount)
    @recent_issues = visible_issues.limit(5)
    @recent_bills = visible_bills.limit(5)
    @recent_users = admin_user? ? User.ordered.limit(5) : []
  end

  def about
  end

  private
    def visible_issues
      scope = Issue.recent_first
      admin_user? ? scope : scope.where(user: current_user)
    end

    def visible_bills
      scope = Bill.recent_first
      admin_user? ? scope : scope.where(user: current_user)
    end
end
