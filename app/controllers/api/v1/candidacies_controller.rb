class Api::V1::CandidaciesController < Api::V1::BaseController
  skip_before_action :authenticate_user!
  skip_before_action :subdomain_authentication!
  skip_before_action :verify_tenant_acces
  skip_before_action :verify_authenticity_token
  acts_as_token_authentication_handler_for User
  before_action :set_candidacy
  respond_to :json

  def show
  end

  def create
    @candidacy.offer = @offer
    @candidacy.candidate = @candidate
    if @candidacy.save
      render :show
    else
      render_error
    end
  end

  def update
    if @candidacy.update(candidacy_params)
      render :show
    else
      render_error
    end
  end

  private

  def set_candidacy
    @candidate = Candidate.find_by(airtable_id: params[:aircandidate_id])
    @offer = Offer.find_by(airtable_id: params[:airoffer_id])
    @candidacy = Candidacy.find_by(offer_id: @offer.id, candidate_id: @candidate.id) || Candidacy.new(candidacy_params)
    authorize @candidacy
  end

  def candidacy_params
    params.require(:candidacy).permit(:selection_status, :application_status)
  end

  def render_error
    render json: { errors: @candidacy.errors.full_messages },
      status: :unprocessable_entity
  end
end
