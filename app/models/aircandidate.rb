Airrecord.api_key = ENV["AIRTABLE_PAT"]

class Aircandidate < Airrecord::Table
  self.base_key = ENV["AIRTABLE_CRM"]
  self.table_name = "Candidats"

  has_many :aircandidacies, class: "Aircandidacy", column: "ATS Test"

  def self.find_by_email(email)
    all(filter: "{Email} = \'#{email}\'")[0]
  end
end
