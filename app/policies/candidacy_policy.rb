class CandidacyPolicy < ApplicationPolicy
  # def show?
  #   record.user == user || user.user_type == 'admin'
  # end

  def create?
    true
  end

  def check?
    true
  end

  def index?
    user.user_type == 'admin'
  end

  def show?
    record.user == user || user.user_type == 'admin'
  end

  def destroy?
    user.user_type == 'admin'
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      case
      when user.company_admin?
        scope.joins(:candidate, :user).where(user: {company_id: user.company_id})
      when user.company_user?
        scope.joins(candidate: :user).where(user: {id: user.id})
      when user.admin?
        true
      else
        false
      end
    end
  end
end
