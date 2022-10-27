class PagesController < ApplicationController
  before_action :new
  skip_before_action :authenticate_user!

  def home
    @beneficiaries = Beneficiary.joins(:offers).where(offers: { status: 'active' }).uniq
  end

  def candidates
  end

  def nonprofits
  end

  def companies
  end

  private

  def new
    @contact = Contact.new
  end
end
