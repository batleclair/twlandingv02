class CompanyAdmin::SelectionsController < CompanyAdminController
  def create
    @selection = Selection.new(selection_params)
    @offer = Offer.find_by(slug: params[:admin_offer_slug])
    @selection.offer = @offer
    authorize @selection
    @candidates = policy_scope(Candidate).select{|c| c.user.last_employee_application&.approved?}
    @selected_candidates = @candidates.select{|c| c.selections.find_by(offer_id: @offer.id).present?}
    @selection.origin = "company_admin"
    if @selection.save
      redirect_to admin_offer_path(@selection.offer)
    else
      render 'company_admin/offers/show', status: :see_other
    end
  end

  private

  def selection_params
    params.require(:selection).permit(:candidate_id, :offer_slug)
  end
end
