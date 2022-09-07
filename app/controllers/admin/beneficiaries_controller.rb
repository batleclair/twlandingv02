class Admin::BeneficiariesController < AdminController
  def new
    @beneficiary = Beneficiary.new
    authorize @beneficiary
  end

  def index
    @beneficiaries = Beneficiary.all
    authorize @beneficiaries
  end

  def edit
    @beneficiary = Beneficiary.find(params[:id])
    authorize @beneficiary
  end
end
