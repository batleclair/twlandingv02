class UserPolicy < ApplicationPolicy

  def index?
    user.admin? || user.company_admin?
  end

  def new?
    index?
  end

  def create?
    index?
  end

  def edit?
    index?
  end

  def update?
    index?
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      case
      when user.admin?
        scope.all
      when user.company_admin?
        scope.where(company_id: user.company_id)
      else
        scope.where(user: user)
      end
    end
  end
end
