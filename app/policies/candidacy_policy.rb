class CandidacyPolicy < ApplicationPolicy
  def create?
    true
  end

  def check?
    true
  end

  def index?
    user.user_type == 'admin'
  end

  def show?
    user.user_type == 'admin'
  end

  def destroy?
    user.user_type == 'admin'
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
