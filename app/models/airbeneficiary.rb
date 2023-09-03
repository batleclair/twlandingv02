Airrecord.api_key = ENV["AIRTABLE_PAT"]

class Airbeneficiary < Airrecord::Table
  self.base_key = ENV["AIRTABLE_CRM"]
  self.table_name = "Associations"

  has_many :airoffers, class: "Airoffer", column: "Offres"
end
