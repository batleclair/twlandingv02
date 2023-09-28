class MissionPolicy < ApplicationPolicy

  def create?
    user.admin? || user.company_admin?
  end

  def new?
    create?
  end

  def show?
    user.role == "admin" ||
    (user.company_admin? && record.candidate.user.company_id == user.company_id) ||
    (user.company_user? && record.candidate == user.candidate)
  end

  def edit?
    show?
  end

  def update?
    show?
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      case
      when user.company_admin?
        scope.joins(candidacy: [{candidate: {user: :company}}]).where(user: {company_id: user.company_id})
      when user.company_user?
        scope.joins(:candidacy).where(candidacy: {candidate_id: user.candidate.id})
      when user.admin?
        scope.all
      else
        false
      end
    end
  end
end
