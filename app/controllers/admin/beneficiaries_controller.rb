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
    @beneficiary = Beneficiary.find_by(slug: params[:slug])
    authorize @beneficiary
  end
end
