class Admin::CompaniesController < ApplicationController
  before_action :set_company, only: [:edit, :update, :destroy]

  def new
    @company = Company.new
  end

  def index
    @companies = Company.all
  end

  def create
    @company = Company.new(company_params)
    if @company.save
      redirect_to admin_companies_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    @company.update(company_params)
    if @company.save
      redirect_to admin_companies_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @company.destroy
    redirect_to admin_companies_path, status: :see_other
  end

  private

  def set_company
    @company = Company.find(params[:id])
  end

  def company_params
    params.require(:company).permit(:name, :slug, :logo)
  end
end
