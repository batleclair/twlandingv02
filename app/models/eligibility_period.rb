class EligibilityPeriod < ApplicationRecord
  belongs_to :company
  validates :title, presence: {message: "Titre requis"}
  has_many :employee_applications, dependent: :nullify

  def title_and_dates
    "#{title} | #{start_date&.strftime("%d/%m/%Y")} -> #{end_date&.strftime("%d/%m/%Y")}"
  end
end
