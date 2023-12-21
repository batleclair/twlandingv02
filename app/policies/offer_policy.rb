class OfferPolicy < ApplicationPolicy
  def show?
    if user.company_user?
      user.candidate.candidacies.find_by(offer: record) || record.in_rule_for?(user)
    else
      true
    end
  end

  def dead?
    true
  end

  def index?
    true
  end

  def select?
    true
  end

  def preview?
    true
  end

  def create?
    user.admin?
  end

  def update?
    create?
  end

  def destroy?
    create?
  end

  def preview?
    show?
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      if user
        case
        when user.company_user? && user.company.offer_rule.full_remote
          scope.where('half_days_min <= ?', user.company.offer_rule.half_days_max)&.and(
            scope&.where('months_min <= ?', user.company.offer_rule.months_max))&.and(
              scope&.where(full_remote: user.company.offer_rule.full_remote))
        when user.company_user? && !user.company.offer_rule.full_remote
          offers = scope.where('half_days_min <= ?', user.company.offer_rule.half_days_max)&.and(
            scope&.where('months_min <= ?', user.company.offer_rule.months_max))
        when user.admin?
          scope.where(publish: true)
        else
          scope.where(status: ["active", "upcoming"], publish: true)
        end
      else
        scope.where(status: ["active", "upcoming"], publish: true)
      end
    end
  end
end
