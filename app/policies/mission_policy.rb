class MissionPolicy < ApplicationPolicy

  def create?
    user.role == "admin" || user.role == "company_admin"
  end

  def new?
    user.role == "admin" || user.role == "company_admin"
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
