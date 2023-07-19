class SelectionPolicy < ApplicationPolicy

  def create?
    case
    when user.company_user?
      record.candidate.user == user
    when user.company_admin?
      (record.candidate.nil? || record.offer.nil?) ? true : record.candidate.user.company == user.company
    when user.admin?
      true
    else
      false
    end
  end

  def show?
    create?
  end

  def update?
    create?
  end

  def destroy?
    case
    when user.company_user?
      record.liked? && record.candidate == user.candidate && record.pending?
    when user.company_admin?
      record.suggested? && record.candidate.user.company == user.company && record.pending?
    when user.admin?
      true
    else
      false
    end

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
