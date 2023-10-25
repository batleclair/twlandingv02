class Admin::EligibilityPeriodsController < ApplicationController
  def index
    set_periods_and_company
    @period = EligibilityPeriod.new
  end

  def create
    @period = EligibilityPeriod.new(period_params)
    set_periods_and_company
    @period.company = @company
    if @period.save
      redirect_to admin_company_eligibility_periods_path(company_id: @period.company_id)
    else
      render :index, status: :unprocessable_entity
    end
  end

  private

  def set_periods_and_company
    @company = Company.find(params[:company_id])
    @periods = EligibilityPeriod.where(company_id: @company.id)
  end

  def period_params
    params.require(:eligibility_period).permit(:start_date, :end_date, :title)
  end
end
