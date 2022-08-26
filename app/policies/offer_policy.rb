class OfferPolicy < ApplicationPolicy
  def show?
    record.status == 'active' || user.user_type == 'admin'
  end

  def create?
    user.user_type == 'admin'
  end

  def update?
    user.user_type == 'admin'
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end
end
