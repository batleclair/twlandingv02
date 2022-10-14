class ExperiencesController < ApplicationController
  def create
    @experience = Experience.new(experience_params)
    input_to_date
    authorize @experience
    @experience.candidate = Candidate.find(params[:candidate_id])
    @experience.save
    @experiences = Experience.where(candidate_id: params[:candidate_id]).order(start_date: :desc)
    respond_to do |format|
      format.json { render :list }
    end
  end

  def select
    params[:id] == "nil" ? @experience = Experience.new : @experience = Experience.find(params[:id])
    authorize @experience
    respond_to do |format|
      format.json { render :select }
    end
  end

  def update
    @experience = Experience.find(params[:id])
    authorize @experience
    @experience.update(experience_params)
    @experiences = Experience.where(candidate_id: @experience.candidate_id).order(start_date: :desc)
    respond_to do |format|
      format.json { render :list }
    end
  end

  def destroy
    @experience = Experience.find(params[:id])
    authorize @experience
    @experience.destroy
    @experiences = Experience.where(candidate_id: @experience.candidate_id).order(start_date: :desc)
    respond_to do |format|
      format.json { render :list }
    end
  end

  private

  # def json_response(xp)
  #   {
  #     valid: xp.valid?,
  #     id: xp.id,
  #     errors: xp.errors,
  #   }
  # end

  # def input_to_date(input)
  #   DateTime.new(input[3..].to_i, input[0..1].to_i)
  # end

  # def convert_dates
  #   self.start_date = params[:start_date].input_to_date
  #   self.end_date = params[:end_date].input_to_date
  # end

  def input_to_date
    @experience.start_date = "#{params[:experience][:start_date][3..]}/#{params[:experience][:start_date][0..1]}"
    @experience.end_date = "#{params[:experience][:end_date][3..]}/#{params[:experience][:end_date][0..1]}" unless @experience.end_date.blank?
  end

  # def date_to_output
  #   @experience.start_date = "#{start_date}/#{params[:experience][:start_date][0..1]}"
  #   @experience.end_date = "#{params[:experience][:end_date][3..]}/#{params[:experience][:end_date][0..1]}" unless @experience.end_date.blank?
  # end

  def experience_params
    params.require(:experience).permit(:title, :employer, :start_date, :end_date)
  end
end
