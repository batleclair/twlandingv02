class ContactPolicy < ApplicationPolicy
  def create?
    true
  end

  def generate?
    create?
  end

  def company_contact?
    create?
  end

  def index?
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
