json.candidate do
  json.id @candidate.id
  json.air_id @candidate.airtable_id
  json.full_name @candidate.full_name
end

json.offer do
  json.id @offer.id
  json.air_id @offer.airtable_id
  json.beneficiary @offer.beneficiary.name
  json.title @offer.title
end

json.candidacy do
  json.selection_status @candidacy.selection_status
  json.application_status @candidacy.application_status
end
