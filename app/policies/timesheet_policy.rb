class TimesheetPolicy < ApplicationPolicy

  def new?
    create?
  end

  def create?
    case
    when user.company_admin?
      record.company == user.company
    when user.company_user?
      record.candidate == user.candidate && record.mission.activated_status?
    when user.admin?
      true
    end
  end

  def show?
    case
    when user.company_admin?
      record.company == user.company
    when user.company_user?
      record.candidate == user.candidate
    when user.admin?
      true
    end
  end

  def edit?
    create?
  end

  def update?
    create?
  end

  def destroy?
    create?
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!

    def resolve
      case
      when user.company_user?
        scope.joins(:mission, :candidacy, :candidate).where(candidate: {user_id: user.id})
      when user.admin?
        scope.all
      else
        false
      end
    end
  end
end
