class Candidate < ApplicationRecord

  belongs_to :user
  has_many :candidacies, dependent: :destroy
  has_many :experiences, dependent: :destroy
  has_one_attached :cv
  has_one_attached :photo
  acts_as_taggable_on :skills
  acts_as_taggable_on :causes

  validates :phone_num, presence: { message: "Renseigner un numéro de tel" }
  validates :status, presence: { message: "Sélectionner parmi les options" }
  validates :employer_name, presence: { message: "Renseigner l'employeur actuel" }, if: :employed?

  validates :function, inclusion: { in: Offer::FUNCTIONS, message: "Sélectionnez un domaine d'expertise" }, on: :min_info
  validates :birth_date, presence: { message: "Indiquer une date de naissance" }, on: :min_info
  validates :title, presence: { message: "Indiquer un intitulé de job ou une expertise" }, on: :min_info
  validates :location, presence: { message: "Indiquer votre ville de résidence" }, on: :min_info

  validate :basics
  validate :cv_file_type

  FUNCTIONS = Offer::FUNCTIONS

  def employed?
    status == 'pt_employee' || status == 'ft_employee'
  end

  def info_missing?
    title.blank? || location.blank? || function.blank? || birth_date.blank?
  end

  def age
    birth_date.present? ? "#{(Date.current - birth_date).fdiv(365).floor} ans" : 'âge incconu'
  end

  def clean_linkedin_url
    "https://#{linkedin_url}" unless linkedin_url.start_with?('http://') || linkedin_url.start_with?('https://')
  end

  private

  def basics
    pattern = /^((https?)(:\/\/))?(www.)?linkedin.[a-z]{2,3}\/in\/\w+\/?$/
    if linkedin_url.blank? && !cv.attached?
      errors.add(:cv, "Veuillez fournir a minima votre LinkedIn OU votre CV")
    elsif linkedin_url.present? && !linkedin_url.match?(pattern)
      errors.add(:linkedin_url, "Oh oh.. le lien indiqué semble erroné")
    end
  end

  def cv_file_type
    if cv.attached?
      errors.add(:cv, 'formats : PDF ou DOC') unless cv.content_type.in?(%w[application/pdf application/msword])
    end
  end

end
