class CandidaciesController < ApplicationController
  def new
    @offer = Offer.find(params[:offer_id])
    @candidacy = Candidacy.new
  end

  def create
    @candidacy = Candidacy.new(candidacy_params)
    @candidacy.offer_id = params[:offer_id].to_i
    @candidacy.candidate_id = current_user.candidate.id
    @candidacy.employer_ok_chance = params[:employer_ok_chance].to_i
    @candidacy.half_days_wish = params[:half_days_wish].to_i
    # @candidacy.start_date_wish = Date.parse(params[:start_date_wish])
    @candidacy.save
    p @candidacy
    p @candidacy.valid?
    render json: {
      offer: @candidacy.offer_id,
      consent: @candidacy.consent,
      ok: @candidacy.employer_ok_chance,
      frequency: @candidacy.half_days_wish,
      aware: @candidacy.employer_aware,
      start: @candidacy.start_date_wish,
      name: @candidacy.employer_name,
      msg: @candidacy.motivation_msg
    }
  end

  private

  def candidacy_params
    params.require(:candidacy).permit(:consent, :employer_name, :employer_aware, :employer_ok_chance, :half_days_wish, :start_date_wish, :motivation_msg)
  end
end
