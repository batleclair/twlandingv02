class Admin::WhitelistsController < ApplicationController
  def index
    set_whitelists_and_company
    @whitelist = Whitelist.new
    @whitelist.company = @company
  end

  def create
    @company = Company.find(params[:company_id])
    @whitelist = Whitelist.new(whitelist_params)
    @whitelist.company = @company
    if @whitelist.save
      redirect_to admin_company_whitelists_path
    else
      set_whitelists_and_company
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    @whitelist = Whitelist.find(params[:id])
    @whitelist.destroy
    redirect_to admin_company_whitelists_path, status: :see_other
  end

  private

  def set_whitelists_and_company
    @company = Company.find(params[:company_id])
    @whitelists = Whitelist.where(company_id: @company.id)
  end

  def whitelist_params
    params.require(:whitelist).permit(:input_type, :input_format, :input_custom, :catch_all, :pre_approval)
  end

end
