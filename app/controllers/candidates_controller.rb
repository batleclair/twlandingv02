class CandidatesController < ApplicationController
  before_action :set_candidate, only: %i[show edit update]
  respond_to :html, :xml, :json

  def show
    authorize @candidate
    @offers = Offer.where(function: @candidate.function).limit(3)
  end

  def new
    @candidate = Candidate.new
    authorize @candidate
  end

  def edit
    authorize @candidate
    @experience = Experience.new
  end

  def create
    @candidate = Candidate.new(candidate_params)
    authorize @candidate
    @candidate.user_id = current_user.id
    if @candidate.save
      redirect_to candidate_path(@candidate)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def synch_create
    @candidate = Candidate.new(candidate_params)
    authorize @candidate
    @candidate.user_id = current_user.id
    @candidate.save
    @candidate.valid?
    render json: json_response(@candidate)
  end

  def synch_update
    @candidate = Candidate.find_by(user_id: current_user.id)
    authorize @candidate
    @candidate.update(candidate_params)
    @candidate.valid?
    render json: json_response(@candidate)
  end

  def synch_update_min
    @candidate = Candidate.find_by(user_id: current_user.id)
    authorize @candidate
    @candidate.update(candidate_params)
    @candidate.valid?(:min_info)
    render json: json_resp_min(@candidate)
  end

  def update
    authorize @candidate
    @candidate.update(candidate_params)
    if @candidate.save
      redirect_to candidate_path(@candidate)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def json_response(candidate)
    {
      valid: candidate.valid?,
      id: candidate.id,
      errors: candidate.errors
    }
  end

  def json_resp_min(candidate)
    {
      valid: candidate.valid?(:min_info),
      id: candidate.id,
      errors: candidate.errors
    }
  end

  def set_candidate
    @candidate = Candidate.find(params[:id])
  end

  def candidate_params
    params.require(:candidate).permit(
      :linkedin_url,
      :phone_num,
      :cv,
      :status,
      :title,
      :location,
      :employer_name,
      :photo,
      :description,
      :skill_list,
      :function,
      :birth_date,
      :past_employer_list,
      cause_list: []
    )
  end
end
