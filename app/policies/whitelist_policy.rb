class WhitelistPolicy < ApplicationPolicy

  def create?
    case
    when user.company_admin?
      record.company_id = user.company_id
    when user.admin?
      true
    else
      false
    end
  end

  def edit?
    create?
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      case
      when user.company_admin?
        scope.where(company_id: user.company_id)
      when user.admin?
        true
      else
        false
      end
    end

  end
end
