class EmployeeApplicationPolicy < ApplicationPolicy

  def new?
    user.company_admin? || user.company_user?
  end

  def index?
    new?
  end

  def create?
    new?
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      case
      when user.company_admin?
        scope.joins(:user).where(user: {company_id: user.company_id})
      when user.company_user?
        scope.where(user: user)
      when user.admin?
        true
      else
        false
      end
    end
  end
end
