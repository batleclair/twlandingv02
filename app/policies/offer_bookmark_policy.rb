class OfferBookmarkPolicy < ApplicationPolicy
  def create?
    user.user_type == 'admin'
  end

  def destroy?
    create?
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
