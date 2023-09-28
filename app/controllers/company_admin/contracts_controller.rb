class CompanyAdmin::ContractsController < ApplicationController
  def destroy
    @contract = Contract.find(params[:id])
    authorize(@contract)
    if @contract.destroy
      redirect_to after_destroy_path, status: :see_other
    end
  end
end

private

def after_destroy_path
  case @contract.contractable_type
  when "Mission"
    company_admin_mission_path(@contract.contractable, view: "documents")
  else
    root_path
  end
end
