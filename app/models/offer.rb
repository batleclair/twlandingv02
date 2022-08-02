class Offer < ApplicationRecord
  belongs_to :beneficiary
  has_rich_text :description
  has_many :candidacies

  def active?
    status == 'active'
  end

  def new?
    status == 'new'
  end

end
