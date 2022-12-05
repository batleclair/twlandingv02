class PagesController < ApplicationController
  before_action :new
  skip_before_action :authenticate_user!

  def home
    @beneficiaries = (Beneficiary.joins(:offers).where(offers: { status: 'active', publish: true }).or(Beneficiary.joins(:offers).where(offers: { status: 'old' }))).uniq
    @offers = Offer.where(publish: true, status: 'active').sample(6)
  end

  def candidates
    @offers = Offer.where(publish: true, status: 'active').sample(6)
  end

  def nonprofits
  end

  def companies
  end

  def terms
  end

  def legal
  end

  def sitemap
    @offers = Offer.where(publish: true, status: 'active')
    @posts = Post.where(publish: true)
  end

  private

  def new
    @contact = Contact.new
  end
end
