class Company < ApplicationRecord
  validates :name, uniqueness: { message: "Ce nom d'entreprise existe déjà" }
  has_many :users, dependent: :destroy
  has_many :contracts
  has_one_attached :logo, dependent: :purge
  has_many :questions, dependent: :destroy
  has_many :employee_applications, through: :users
  has_many :whitelists, dependent: :destroy
  has_many :eligibility_periods, dependent: :destroy
  has_one :offer_rule, dependent: :destroy
  enum :status, {inactive: 0, demo: 1, active: 2}, suffix: true

  def catch_all_domains
    a = []
    records = whitelists.where(input_type: :domain, catch_all: true)
    records.each {|record| a << record.input_format}
    return a
  end

  def single_use_domains
    a = []
    records = whitelists.where(input_type: :domain, catch_all: false)
    records.each {|record| a << record.input_format}
    return a
  end
end
