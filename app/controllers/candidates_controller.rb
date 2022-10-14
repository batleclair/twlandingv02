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
    if current_user.candidate.nil?
      @candidate = Candidate.new(candidate_params)
      authorize @candidate
      @candidate.user_id = current_user.id
      @candidate.save
      @candidate.valid?
      render json: json_response(@candidate)
    end
  end

  def synch_update
    @candidate = Candidate.find_by(user_id: current_user.id)
    authorize @candidate
    @candidate.update(candidate_params)
    @candidate.valid?
    render json: json_response(@candidate)
  end

  def update
    authorize @candidate
    @candidate.update(candidate_params)
    @candidate.valid?
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
      :past_employer_list,
      cause_list: []
    )
  end
end
