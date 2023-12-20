class ContractPolicy < ApplicationPolicy

  def new?
    user.admin? || user.company_admin?
  end

  def create?
    user.admin? || (record.company == user.company && user.company_admin?)
  end

  def destroy?
    create?
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
