class PagesController < ApplicationController
  before_action :new
  skip_before_action :authenticate_user!

  def home
    @beneficiaries = Beneficiary.where(publish_logo: true)
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

  def privacy
    add_breadcrumb "Politique de Confidentialité", privacy_policy_path
  end

  def about
    add_breadcrumb "A propos", about_path
  end

  def sitemap
    @offers = Offer.where(publish: true, status: 'active')
    @beneficiaries = Beneficiary.where(publish_logo: true)
    @posts = Post.where(publish: true)
  end

  private

  def ats_params
    params.permit(:test)
  end

  def new
    @contact = Contact.new
  end
end
