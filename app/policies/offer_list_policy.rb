class OfferListPolicy < ApplicationPolicy
  def show?
    true
  end

  def index?
    user.user_type == 'admin'
  end

  def new?
    index?
  end

  def edit?
    index?
  end

  def create?
    index?
  end

  def update?
    index?
  end

  def destroy?
    index?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
