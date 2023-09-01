class Admin::EmployeeApplicationsController < ApplicationController
  before_action :set_employee_application, only: [:edit, :update, :destroy]

  def index
    @employee_applications = policy_scope(EmployeeApplication)
  end

  def edit
  end

  def update
    @employee_application.update(employee_application_params)
    if @employee_application.save
      redirect_to admin_employee_applications_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @employee_application.destroy
    redirect_to admin_employee_applications_path, status: :see_other
  end

  private

  def set_employee_application
    @employee_application = EmployeeApplication.find(params[:id])
  end

  def employee_application_params
    params.require(:employee_application).permit(:status, :response_msg)
  end
end
