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
    user.company_admin? || user.company_user? || user.admin?
  end

  def new?
    update?
  end

  def show_selection?
    show?
  end

  def show?
    true
    # record.user == user || user.user_type == 'admin'
  end

  def update?
    record.user == user ||
    (user.company_admin? && record.user.company_id == user.company_id) ||
    user.admin?
  end

  def submit?
    user.company_user? && record.user == user
  end

  def destroy?
    case
    when user.admin?
      true
    when user.company_user?
      record.user == user
    else
      false
    end
  end

  def bookmarks?
    index?
  end

  def historicals?
    user.company_user? || user.admin?
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
        scope.all
      else
        false
      end
    end
  end
end
