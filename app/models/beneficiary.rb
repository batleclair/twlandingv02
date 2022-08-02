class Beneficiary < ApplicationRecord
  has_many :offers
  has_one_attached :photo
  has_one_attached :logo
  validate :basics
  validate :logo_file_type

  private

  def basics
    if name.blank? && !logo.attached?
      errors.add(:basics, "super cool")
    end
  end

  def logo_file_type
    if logo.attached?
      errors.add(:logo, 'formats : jpeg, png ou gif') unless logo.content_type.in?(%w[image/jpeg image/png image/gif])
    end
  end

end
