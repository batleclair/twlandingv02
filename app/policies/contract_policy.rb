class ContractPolicy < ApplicationPolicy

  def destroy?
    user.admin? || (record.company == user.company && user.company_admin?)
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
