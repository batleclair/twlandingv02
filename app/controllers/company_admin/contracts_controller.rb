class CompanyAdmin::ContractsController < CompanyAdminController

  def new
    @mission = Mission.find(params[:company_admin_mission_id])
    @contract = Contract.new
    authorize @contract
  end

  def create
    @mission = Mission.find(params[:company_admin_mission_id])
    @contract = Contract.new(contract_params)
    @contract.company = current_user.company
    @contract.contractable = @mission
    if @contract.save
      redirect_back(fallback_location: root_path)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @contract = Contract.find(params[:id])
    authorize(@contract)
    if @contract.destroy
      redirect_to after_destroy_path, status: :see_other
    end
  end

  private

  def contract_params
    params.require(:contract).permit(:title, :contract_type, :document)
  end

  def after_destroy_path
    case @contract.contractable_type
    when "Mission"
      company_admin_mission_documents_path(@contract.contractable, view: params[:view])
    else
      root_path
    end
  end
end
