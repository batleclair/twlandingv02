class Company < ApplicationRecord
  validates :name, uniqueness: { message: "Ce nom d'entreprise existe déjà" }
  has_many :users
  has_many :contracts
  has_one_attached :logo
  has_many :questions
  has_many :whitelists
  has_many :eligibility_periods

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
