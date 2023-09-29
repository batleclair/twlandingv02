class FeedbackPolicy < ApplicationPolicy

  def create?
    case
    when user.company_admin?
      false
    when user.company_user?
      record.user == user
    when user.admin?
      true
    end
  end

  def new?
    create?
  end

  def edit?
    create?
  end

  def update?
    create?
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
