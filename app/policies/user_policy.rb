class UserPolicy < ApplicationPolicy

  def index?
    user.user_type == 'admin'
  end

  def new?
    index?
  end

  def create?
    index?
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
