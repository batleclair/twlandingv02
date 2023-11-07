class CompanyAdmin::WhitelistsController < CompanyAdminController
  before_action :set_tab, only: [:index]

  def index
    set_whitelists
    @whitelist = Whitelist.new
  end

  def create
    @whitelist = Whitelist.new(whitelist_params)
    authorize @whitelist
    @whitelist.company = current_user.company
    @whitelist.input_type = "email"
    if @whitelist.save
      redirect_to company_admin_whitelists_path, status: :see_other
    else
      set_whitelists
      set_tab
      @error = true
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    @whitelist = Whitelist.find(params[:id])
    @whitelist.destroy
    redirect_to company_admin_whitelists_path, status: :see_other
  end

  private

  def set_whitelists
    @whitelists = policy_scope(Whitelist).order(created_at: :desc)
  end

  def whitelist_params
    params.require(:whitelist).permit(:input_format, :input_custom, :pre_approval)
  end

  def set_tab
    @tab = 2
  end
end
