class DashboardPolicy < ApplicationPolicy
  def super_admin?
    user.admin?
  end

  def company_admin?
    user.company_admin?
  end

  def company_user?
    user.company_user?
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
