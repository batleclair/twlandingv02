class ExperiencePolicy < ApplicationPolicy

  def check?
    true
  end

  def select?
    true
  end

  def create?
    true
  end

  def update?
    true
  end

  def destroy?
    true
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.where(candidate: user.candidate)
    end
  end
end
