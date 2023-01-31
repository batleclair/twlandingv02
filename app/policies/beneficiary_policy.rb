class BeneficiaryPolicy < ApplicationPolicy
  def index?
    user.user_type == 'admin'
  end

  def show?
    true
  end

  def unpublished?
    true
  end

  def create?
    index?
  end

  def update?
    index?
  end

  def destroy_img?
    index?
  end

  def destroy?
    index?
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end
end
