class PagesController < ApplicationController
  before_action :new
  skip_before_action :authenticate_user!

  def home
    @beneficiaries = Beneficiary.joins(:offers).where(offers: { status: 'active', publish: true }).uniq
    @offers = Offer.where(publish: true, status: 'active').order(created_at: :desc).limit(6)
  end

  def candidates
  end

  def nonprofits
  end

  def companies
  end

  def terms
  end

  def legal
  end

  private

  def new
    @contact = Contact.new
  end
end
