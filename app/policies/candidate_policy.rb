class CandidatePolicy < ApplicationPolicy

  def show?
    record.user == user || user.user_type == 'admin'
  end

  def new?
    user.candidate.blank?
  end

  def create?
    true
  end

  def synch_update?
    update?
  end

  def update?
    record.user == user || user.user_type == 'admin'
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
