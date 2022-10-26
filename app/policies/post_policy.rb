class PostPolicy < ApplicationPolicy

  def index?
    true
  end

  def show?
    record.publish
  end

  def new?
    create?
  end

  def create?
    user.user_type == 'admin'
  end

  def edit?
    update?
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
      scope.where(publish: true)
    end
  end
end
