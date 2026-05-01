class PostPolicy < ApplicationPolicy
  def update?
    record.user == user
  end

  def destroy?
    record.user == user
  end

  def create?
    user.present?
  end

  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
