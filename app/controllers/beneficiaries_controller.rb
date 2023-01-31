class BeneficiariesController < ApplicationController
  before_action :set_beneficiary, only: %i[show edit update destroy destroy_img]
  skip_before_action :authenticate_user!, only: %i[show unpublished]

  def index
    @beneficiaries = policy_scope(Beneficiary)
    @beneficiary = Beneficiary.new
    authorize @beneficiary
  end

  def show
    authorize @beneficiary
    @offers = @beneficiary.offers.select(`&:public?`)
    add_breadcrumb "Associations"
    add_breadcrumb @beneficiary.name, beneficiary_path(@beneficiary)
    return if (user_signed_in? && current_user&.admin?) || @beneficiary.publish

    redirect_to unpublished_beneficiary_path, status: 301
  end

  def unpublished
    @beneficiary = Beneficiary.new
    authorize @beneficiary
  end

  def create
    @beneficiary = Beneficiary.new(beneficiary_params)
    authorize @beneficiary
    @beneficiary.save
    if @beneficiary.save
      @beneficiary.set_slug
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

  def destroy_img
    authorize @beneficiary
    @beneficiary.send(params[:img]).purge
    @beneficiary.save
    redirect_to edit_admin_beneficiary_path(@beneficiary), status: :see_other
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
      :kpt_three,
      :publish,
      :publish_logo
    )
  end
end
