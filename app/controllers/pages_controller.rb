class PagesController < ApplicationController
  before_action :new
  skip_before_action :authenticate_user!

  def home
    @beneficiaries = (Beneficiary.joins(:offers).where(offers: { status: 'active', publish: true }).or(Beneficiary.joins(:offers).where(offers: { status: 'old' }))).uniq
    @offers = Offer.where(publish: true, status: 'active').sample(6)
  end

  def candidates
    @offers = Offer.where(publish: true, status: 'active').sample(6)
    add_breadcrumb "Candidats", candidates_path
  end

  def nonprofits
    add_breadcrumb "Associations", nonprofits_path
  end

  def companies
    add_breadcrumb "Entreprises", companies_path
  end

  def terms
    add_breadcrumb "CGU", terms_path
  end

  def legal
    add_breadcrumb "Légal", legal_path
  end

  def about
    add_breadcrumb "A propos", about_path
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
