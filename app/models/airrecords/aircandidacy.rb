Airrecord.api_key = ENV["AIRTABLE_PAT"]

class Aircandidacy < Airrecord::Table
  self.base_key = ENV["AIRTABLE_CRM"]
  self.table_name = "< ATS >"

  belongs_to :aircandidate, class: "Aircandidate", column: "Candidat"
  belongs_to :airoffer, class: "Airoffer", column: "Offres"
end
