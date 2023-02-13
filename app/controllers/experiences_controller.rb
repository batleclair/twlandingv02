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
    input_to_date
    @experience.save
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

  def input_to_date
    @experience.start_date = "#{params[:experience][:start_date][3..]}/#{params[:experience][:start_date][0..1]}"
    @experience.end_date = "#{params[:experience][:end_date][3..]}/#{params[:experience][:end_date][0..1]}" unless @experience.end_date.blank?
  end

  def experience_params
    params.require(:experience).permit(:title, :employer, :start_date, :end_date)
  end
end
