class CandidaciesController < ApplicationController
  def new
    @offer = Offer.find(params[:offer_id])
    @candidacy = Candidacy.new
  end

  def check
    @candidacy = Candidacy.new(candidacy_params)
    @candidacy.offer_id = params[:offer_id]
    @candidacy.candidate_id = current_user.candidate.id
    @candidacy.valid?
    render json: json_response(@candidacy)
  end

  def create
    @candidacy = Candidacy.new(candidacy_params)
    @candidacy.offer_id = params[:offer_id]
    @candidacy.candidate_id = current_user.candidate.id
    @candidacy.valid?
    if @candidacy.save
      render json: json_confirmation(@candidacy)
    else
      render json: { employer_name: @candidacy.errors[:employer_name].first }
    end
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
