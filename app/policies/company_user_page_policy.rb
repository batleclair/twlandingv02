class CompanyUserPagePolicy < ApplicationPolicy

  def dashboard?
    user.company_user?
  end

  def on_boarding?
    dashboard?
  end

  def book_call?
    dashboard?
  end

  def restricted?
    dashboard?
  end

  def no_mission?
    dashboard?
  end

  def info?
    dashboard?
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
