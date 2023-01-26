class BeneficiariesController < ApplicationController
  before_action :set_beneficiary, only: %i[show edit update destroy destroy_logo]
  skip_before_action :authenticate_user!, only: %i[show]
  after_action :save_and_redirect, only: %i[destroy_logo destroy_photo destroy_profile_pic_one destroy_profile_pic_two destroy_profile_pic_three]

  def index
    @beneficiaries = policy_scope(Beneficiary)
    @beneficiary = Beneficiary.new
    authorize @beneficiary
  end

  def show
    authorize @beneficiary
    @offers = @beneficiary.offers.select { |o| o.public? }
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

  def destroy_logo
    authorize @beneficiary
    @beneficiary.logo.purge
  end

  def destroy_photo
    authorize @beneficiary
    @beneficiary.photo.purge
  end

  def destroy_profile_pic_one
    authorize @beneficiary
    @beneficiary.profile_pic_one.purge
  end

  def destroy_profile_pic_two
    authorize @beneficiary
    @beneficiary.profile_pic_two.purge
  end

  def destroy_profile_pic_three
    authorize @beneficiary
    @beneficiary.profile_pic_three.purge
  end

  def destroy
    @beneficiary.destroy
    authorize @beneficiary
    redirect_to admin_beneficiaries_path, status: :see_other
  end

  private

  def set_beneficiary
    @beneficiary = Beneficiary.find_by(slug: params[:slug])
  end

  def save_and_redirect
    @beneficiary.save
    redirect_to edit_admin_beneficiary_path(@beneficiary), status: :see_other
  end

  def beneficiary_params
    params.require(:beneficiary).permit(
      :name,
      :siren,
      :rna,
      :address,
      :city,
      :cause,
      :logo,
      :photo,
      :goal,
      :description,
      :long_desc,
      :web_url,
      :li_url,
      :start_year,
      :profile_pic_one,
      :profile_pic_two,
      :profile_pic_three,
      :kpi_one,
      :kpi_two,
      :kpi_three,
      :kpt_one,
      :kpt_two,
      :kpt_three
    )
  end
end
