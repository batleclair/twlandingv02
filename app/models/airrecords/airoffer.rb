Airrecord.api_key = ENV["AIRTABLE_PAT"]

class Airoffer < Airrecord::Table
  self.base_key = ENV["AIRTABLE_CRM"]
  self.table_name = "Offres"

  has_many :aircandidacies, class: "Aircandidacy", column: "ATS Test"
end
