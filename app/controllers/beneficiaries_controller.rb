class BeneficiariesController < ApplicationController
  before_action :set_beneficiary, only: %i[show edit update destroy]

  def index
    # @beneficiaries = Beneficiary.all
    @beneficiaries = policy_scope(Beneficiary)
    @beneficiary = Beneficiary.new
    authorize @beneficiary
  end

  def show
    @offers = @beneficiary.offers
    @offer = Offer.new
    @offer.beneficiary = @beneficiary
    authorize @beneficiary
  end

  def create
    @beneficiary = Beneficiary.new(beneficiary_params)
    authorize @beneficiary
    @beneficiary.valid?
    if @beneficiary.save
      redirect_to admin_beneficiaries_path
    else

    end
  end

  def edit
    authorize @beneficiary
  end

  def update
    @beneficiary.update(beneficiary_params)
    authorize @beneficiary
    if @beneficiary.save
      redirect_to admin_beneficiaries_path
    else

    end
  end

  def destroy
    @beneficiary.destroy
    authorize @beneficiary
    redirect_to admin_beneficiaries_path, status: :see_other
  end

  private

  def set_beneficiary
    @beneficiary = Beneficiary.find(params[:id])
  end

  def beneficiary_params
    params.require(:beneficiary).permit(:name, :siren, :rna, :address, :city, :cause, :logo, :photo, :goal)
  end
end
