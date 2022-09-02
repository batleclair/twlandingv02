class Candidate < ApplicationRecord
  belongs_to :user
  has_many :candidacies, dependent: :destroy
  has_one_attached :cv

  validates :phone_num, presence: { message: "Veuillez renseigner votre tel" }
  validates :status, presence: { message: "Veuillez sélectionner parmi les options" }
  validate :basics
  validate :cv_file_type

  private

  def basics
    if linkedin_url.blank? && !cv.attached?
      errors.add(:cv, "Veuillez fournir a minima votre LinkedIn OU votre CV")
    end
  end

  def cv_file_type
    if cv.attached?
      errors.add(:cv, 'formats : PDF ou DOC') unless cv.content_type.in?(%w[application/pdf application/msword])
    end
  end
end
