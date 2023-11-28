class Admin::OfferRulesController < ApplicationController
  before_action :set_company_and_rule

  def edit
  end

  def update
    @offer_rule.assign_attributes(offer_rule_params)
    if @offer_rule.save
      redirect_to edit_admin_offer_rule_path(@offer_rule)
      flash[:notice] = "Enregistré !"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_company_and_rule
    @offer_rule = OfferRule.find(params[:id])
    @company = @offer_rule.company
  end

  def offer_rule_params
    params.require(:offer_rule).permit(:commitment, :full_remote, :half_days_max, :months_max)
  end
end
