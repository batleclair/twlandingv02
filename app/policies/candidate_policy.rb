class CandidatePolicy < ApplicationPolicy

  def show?
    record.user == user || user.user_type == 'admin'
  end

  def new?
    create?
  end

  def synch_create?
    create?
  end

  def synch_create_min?
    create?
  end

  def create?
    user.candidate.blank?
  end

  def synch_update?
    update?
  end

  def synch_update_min?
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
