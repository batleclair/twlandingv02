class Admin::CompaniesController < ApplicationController
  before_action :set_company, only: [:edit, :update, :destroy, :reset_demo]
  include CompanyDemo

  def new
    @company = Company.new
  end

  def index
    @companies = Company.all
  end

  def create
    @company = Company.new(company_params)
    if @company.save
      OfferRule.create(company: @company)
      redirect_to edit_admin_company_path(@company)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    domain_format = "#{@company.slug}-demain.works"
    @demo_users = @company.users.select{|u| u.email.slice(/@.+/)&.delete("@") == domain_format}
  end

  def update
    status_on_record = @company.status
    @company.update(company_params)
    if @company.save
      set_or_delete_demo_users if @company.status != status_on_record
      redirect_to edit_admin_company_path(@company)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @company.destroy
    redirect_to admin_companies_path, status: :see_other
  end

  def reset_demo
    reset_demo_for(@company)
  end

  private

  def set_company
    @company = Company.find(params[:id])
  end

  def company_params
    params.require(:company).permit(:name, :slug, :logo, :status)
  end

  def set_or_delete_demo_users
    @company.demo_status? ? set_demo_for(@company) : delete_demo_for(@company)
  end
end
