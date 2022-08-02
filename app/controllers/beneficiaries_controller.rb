class BeneficiariesController < ApplicationController
  before_action :set_beneficiary, only: %i[show edit update destroy]

  def index
    @beneficiaries = Beneficiary.all
    @beneficiary = Beneficiary.new
  end

  def show
    @offers = @beneficiary.offers
    @offer = Offer.new
    @offer.beneficiary = @beneficiary
  end

  def create
    @beneficiary = Beneficiary.new(beneficiary_params)
    @beneficiary.valid?
    if @beneficiary.save
      redirect_to beneficiaries_path
    else

    end
  end

  def edit
  end

  def update
    @beneficiary.update(beneficiary_params)
    if @beneficiary.save
      redirect_to beneficiaries_path
    else

    end
  end

  def destroy
    @beneficiary.destroy
    redirect_to beneficiaries_path, status: :see_other
  end

  private

  def set_beneficiary
    @beneficiary = Beneficiary.find(params[:id])
  end

  def beneficiary_params
    params.require(:beneficiary).permit(:name, :siren, :rna, :address, :city, :cause, :logo, :photo)
  end
end
