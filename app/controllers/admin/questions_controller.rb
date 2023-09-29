class Admin::QuestionsController < ApplicationController

  def index
    @company = Company.find(params[:company_id])
    @questions = Question.where(company: @company)
    @question = Question.new
    @question.company = @company
  end

  def create
    @company = Company.find(params[:company_id])
    @question = Question.new(question_params)
    @question.company = @company
    if @question.save
      redirect_to admin_company_questions_path
    else
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    @question = Question.find(params[:id])
    @question.destroy
    redirect_to admin_company_questions_path, status: :see_other
  end

  private

  def question_params
    params.require(:question).permit(:input_type, :title)
  end

end
