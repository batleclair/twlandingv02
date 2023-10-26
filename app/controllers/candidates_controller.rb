# require 'airrecords/aircandidate'
# require 'airrecords/aircandidacy'
# require 'airrecords/airoffer'

class CandidatesController < ApplicationController
  include ControllerUtilities

  before_action :set_candidate, only: %i[show update complete]
  respond_to :html, :xml, :json

  def show
    authorize @candidate
    @select_offers = Offer.where(function: @candidate.function).and(Offer.where(publish: true)).limit(3)
    @applied_offers = Offer.joins(:candidacies).where(candidacies: {candidate_id: @candidate.id})
    add_breadcrumb "Mon profil", candidate_path(@candidate)
  end

  def new
    @candidate = current_user.candidate.present? ? current_user.candidate : Candidate.new
    authorize @candidate
    @candidate_on_record = @candidate
  end

  def completed
    @candidate = current_user.candidate
    authorize @candidate
  end

  def edit
    @candidate = current_user.candidate
    authorize @candidate
    @candidate_on_record
    # add_breadcrumb "Mon profil", candidate_path(@candidate)
    # add_breadcrumb "Modification du profil", edit_candidate_path(@candidate)
  end

  def skillset
    @candidate = current_user.candidate
    authorize @candidate
    @experience = Experience.new
  end

  def init
    @candidate = current_user.candidate
    authorize @candidate
  end

  def wishes
    @candidate = current_user.candidate
    authorize @candidate
  end

  def create
    @candidate = Candidate.new(candidate_params)
    authorize @candidate
    @candidate_on_record = Candidate.new
    @candidate.user_id = current_user.id
    if @candidate.save(context: :profile)
      @candidate.clip_to_airtable
      process_profile_completion
      redirect_to users_completed_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def synch_create
    @candidate = Candidate.new(candidate_params)
    authorize @candidate
    @candidate.user_id = current_user.id
    if @candidate.save(context: :apply)
      send_new_candidate_alert
      @candidate.clip_to_airtable
    end
    render json: json_response(:apply)
  end

  def synch_update
    @candidate = Candidate.find_by(user_id: current_user.id)
    authorize @candidate
    @candidate.assign_attributes(candidate_params)
    @candidate.save(context: :apply)
    render json: json_response(:apply)
  end

  def update
    authorize @candidate
    @candidate_on_record = @candidate
    source = params[:source]
    context = source == "new" ? :profile : :apply
    @candidate.assign_attributes(candidate_params)
    saved = @candidate.save(context: context)
    if saved
      if source == "new"
        process_profile_completion
        redirect_to users_completed_path
      else
        process_profile_completion if @candidate.first_completion?
        flash[:notice] = "Vos informations ont bien été enregistrées"
        render params[:source].to_sym, status: :see_other
      end
    else
      render params[:source].to_sym, status: :unprocessable_entity
    end
  end

  def apply
    @candidate = current_user.candidate.nil? ? Candidate.new : current_user.candidate
    authorize @candidate
    @candidate.assign_attributes(candidate_params)
    @offer = Offer.find_by(slug: params[:slug])
    @candidacy = @candidate.candidacies.last
    @candidacy.offer = @offer
    if @candidate.save
      redirect_to candidacy_path(@candidacy)
    else
      set_index
      @modal_open = true
      render "offers/index"
    end
  end

  def destroy
    @candidate = Candidate.find(params[:id])
    @candidate.destroy
    authorize @candidate
    redirect_to admin_candidates_path, status: :see_other
  end

  private

  def json_response(context)
    {
      valid: @candidate.valid?(context),
      id: @candidate.id,
      errors: @candidate.errors
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
      :volunteering,
      :availability,
      :availability_details,
      :remote_work,
      :comment,
      :volunteering_aknowledged,
      primary_cause: [],
      secondary_cause: [],
      candidacies_attributes: [:motivation_msg]
    )
  end

  def send_new_candidate_alert
    CandidateMailer.with(candidate: @candidate).new_candidate_email.deliver_later
  end

  def send_new_profile_alert
    CandidateMailer.with(candidate: @candidate).new_profile_email.deliver_later
  end

  def process_profile_completion
    @candidate.save_to_airtable
    send_new_profile_alert
    @candidate.profile_completed = true
    @candidate.save
  end
end
