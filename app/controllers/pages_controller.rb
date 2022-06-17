class PagesController < ApplicationController
  before_action :new

  def home
  end

  def candidates
  end

  def nonprofits
  end

  def companies
  end

  private

  def new
    @contact = Contact.new
  end
end
