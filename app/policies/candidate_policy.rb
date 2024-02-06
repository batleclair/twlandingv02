class CandidatePolicy < ApplicationPolicy

  def index?
    user.user_type == 'admin'
  end

  def show?
    record.user == user || user.user_type == 'admin'
  end

  def profile?
    show?
  end

  def dashboard?
    show?
  end

  def new?
    record.id.nil? || (record.user == user && !record.profile_completed)
  end

  def synch_create?
    create?
  end

  def apply?
    user.candidate.blank? || record.user == user
  end

  def completed?
    record.user == user && record.profile_completed
  end

  def create?
    user.candidate.blank?
  end

  def skillset?
    record.user == user
  end

  def wishes?
    record.user == user
  end

  def synch_update?
    update?
  end

  def synch_update_min?
    update?
  end

  def update?
    record.user == user || user.admin? || (user.company_admin? && record.user.company_id == user.company_id)
  end

  def update_candidate?
    update?
  end

  def update_user?
    update?
  end

  def destroy?
    user.user_type == 'admin'
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      case
      when user.admin?
        scope.all
      when user.company_admin?
        scope.joins(:user).where(user: {company_id: user.company_id})
      else
        scope.where(user: user)
      end
    end
  end
end
