class CompanyAdminPagePolicy < ApplicationPolicy

  def dashboard?
    user.company_admin?
  end

  def info?
    user.company_admin?
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
