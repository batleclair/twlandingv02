Airrecord.api_key = ENV["AIRTABLE_PAT"]

class Aircandidacy < Airrecord::Table
  self.base_key = ENV["AIRTABLE_CRM"]
  self.table_name = "< ATS >"

  belongs_to :aircandidate, class: "Aircandidate", column: "Candidat"
  belongs_to :airoffer, class: "Airoffer", column: "Offres"

  def status_output  # à harmoniser avec Paul sur Airtable
    case self["Statut"]
    when "7. Intérêt asso"
      "Votre intérêt pour la mission a été signifié à l’association"
    when "8. Entretien asso"
      "L’association est intéressée ! Vous avez été mis·e en contact par email"
    when "9. Validation asso <> candidat"
      "Bravo ! L’association a confirmé vouloir travailler avec vous"
    when "10. Mission en cours"
      "Génial, la mission a été validée ! L’équipe RH est sur le coup"
    when "15. Refus asso"
      "Nous sommes désolés, l'association n'a pas souhaité aller plus loin :("
    when "16. Refus candidat"
      "Nous avons informé l'association que vous ne souhaitiez pas aller plus loin"
    else
      "Les informations ne sont pas disponibles"
    end
  end

  def approved_by_beneficiary
    self["Statut"] == "8. Entretien asso"
  end
end

# 1. Candidature reçue
# 2. Formulaire envoyé
# 3. Formulaire reçu
# 4. Call Demain
# 5. Attente mission
# 6. Proposition missions
# 7. Intérêt asso
# 8. Entretien asso
# 9. Validation asso <> candidat
# 10. Mission en cours
# 11. On-hold / pas dispo (raison dans les notes)
# 12. Drop / non pertinent (raison dans les notes)
# 13. Mission abandonnée
# 14. Mission terminée
# 15. Refus asso
# 16. Refus candidat
