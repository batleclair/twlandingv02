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
    @candidacy.offer_id = params[:id]
    @candidacy.candidate_id = current_user.candidate.id
    @candidacy.valid?
    render json: json_response(@candidacy)
  end

  def create
    @candidacy = Candidacy.new(candidacy_params)
    @candidacy.consent = params['consent'] == 'true'
    authorize @candidacy
    @candidacy.offer = Offer.find_by(slug: params[:offer_slug])
    @candidacy.candidate_id = current_user.candidate.id
    @candidacy.valid?
    log_event if @candidacy.save
    render json: json_response(@candidacy)
  end

  def destroy
    @candidacy = Candidacy.find(params[:id])
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

  def event_params
    {
      data: [
        {
          event_name: "SubmitApplication",
          event_time: Time.now.to_i,
          event_source_url: request.original_url,
          user_data: {
            client_ip_address: request.remote_ip,
            client_user_agent: request.user_agent,
            em: Digest::SHA256.hexdigest(@candidacy.candidate.user.email),
            fn: Digest::SHA256.hexdigest(@candidacy.candidate.user.first_name),
            ln: Digest::SHA256.hexdigest(@candidacy.candidate.user.last_name)
          },
          custom_data: {
            candidate_status: @candidacy.candidate.status
          }
        }
      ]
    }
  end
end
