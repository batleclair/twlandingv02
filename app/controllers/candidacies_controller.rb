class CandidaciesController < ApplicationController
  def new
    @offer = Offer.find(params[:offer_id])
    authorize @offer
    @candidacy = Candidacy.new
    authorize @candidacy
  end

  def check
    @candidacy = Candidacy.new(candidacy_params)
    authorize @candidacy
    @candidacy.consent = true
    @candidacy.offer_id = params[:offer_id]
    @candidacy.candidate_id = current_user.candidate.id
    @candidacy.valid?
    render json: json_response(@candidacy)
  end

  def create
    @candidacy = Candidacy.new(candidacy_params)
    @candidacy.consent = params['consent'] == 'true'
    authorize @candidacy
    @candidacy.offer_id = params[:offer_id]
    @candidacy.candidate_id = current_user.candidate.id
    @candidacy.valid?
    @candidacy.save
    render json: json_response(@candidacy)
  end

  def destroy
    @candidacy.destroy
    authorize @candidacy
    redirect_to admin_candidacies_path, status: :see_other
  end

  private

  def json_response(candidacy)
    {
      valid: candidacy.valid?,
      id: candidacy.id,
      errors: candidacy.errors
    }
  end

  def candidacy_params
    params.require(:candidacy).permit(:consent, :employer_name, :employer_aware, :employer_ok_chance, :half_days_wish, :start_date_wish, :motivation_msg)
  end
end
