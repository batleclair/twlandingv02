class OfferPolicy < ApplicationPolicy
  def show?
    # record.id.nil? || record.publish || user&.user_type == 'admin'
    true
  end

  def index?
    true
  end

  def select?
    true
  end

  def create?
    user.user_type == 'admin'
  end

  def update?
    user.user_type == 'admin'
  end

  def destroy?
    user.user_type == 'admin'
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      (scope.where(status: "active").or(scope.where(status: "upcoming"))).and(scope.where(publish: true))
    end
  end
end
