class EligibilityPeriod < ApplicationRecord
  belongs_to :company

  def title_and_dates
    "#{title} | #{start_date.strftime("%d/%m/%Y")} -> #{end_date.strftime("%d/%m/%Y")}"
  end
end
