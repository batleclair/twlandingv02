module CompanyDemo
  def set_demo_for(company)

    user_count = 6
    pending_candidacy_count = 2
    first_names = ["Sandrine", "Joseph", "Alexandra", "Ismaël", "Jean-Marc", "Sophia"]
    last_names = ["Escudero", "Minguet", "Hiebel", "Ortuño", "Yernaux", "Kadri"]
    domain_format = "#{company.slug}-demain.works"

    application_msg = "Je souhaiterais m'engager sur du mécénat de compétences afin d'aider une association sur mon temps de travail grâce à #{company.name} :)"
    motivation_msg = "Je trouve le projet de votre association fantastique, et il fait écho à mes convictions personnelles. Je pense pouvoir apporter mon aide sur la problématique que vous rencontrez grâcve à mon expertise !"
    submission_msg = "Je souhaite mettre mes compétences au service de cette association qui me tient à coeur"

    Whitelist.create(input_type: :domain, input_format: domain_format, company_id: company.id)
    admin_wl = Whitelist.create(input_type: :email, input_format: "demo.admin-account@#{domain_format}", company_id: company.id, first_name: "Demo", last_name: "Admin-Account", role: :admin)
    for i in 0..(user_count - 1) do
      Whitelist.create(
        input_type: :email,
        input_format: "#{first_names[i].parameterize}@#{domain_format}",
        company_id: company.id,
        first_name: first_names[i],
        last_name: last_names[i]
      )
    end

    admin_user = User.create(first_name: "Demo", last_name: "Admin-Account", company_role: :admin, email: "demo.admin-account@#{domain_format}", password: ENV['DEMO_PASSWORD'], demo: true, company_id: company.id, whitelist_id: admin_wl.id)
    offers_scope = Offer.where(status: "active", publish: true).where.not(title: "no_offer")
    users = []
    approved_candidacies = []
    approved_missions = []

    for i in 0..(user_count - 1) do
      user = User.create(
        first_name: first_names[i],
        last_name: last_names[i],
        email: "#{first_names[i].parameterize}@#{domain_format}",
        password: ENV['DEMO_PASSWORD'],
        company_id: company.id,
        company_role: :user,
        demo: true
      )
      user.whitelist = user.find_whitelist
      user.save
      candidate = Candidate.create(
        user_id: user.id,
        status: Candidate::STATUSES[0],
        employer_name: user.company.name,
        function: Offer::FUNCTIONS.sample
      )
      employee_application = EmployeeApplication.create(
        candidate_id: candidate.id,
        motivation_msg: motivation_msg,
        status: :approved
      )
      users << user
    end

    users.pop.last_employee_application.pending_status!

    users.each do |user|
      candidacy = Candidacy.create(
        offer_id: offers_scope.sample.id,
        candidate_id: user.candidate.id,
        active: true,
        origin: :admin,
        motivation_msg: motivation_msg,
        status: :user_validation,
        comments_attributes: [status: "user_validation", user_id: user.id, content: submission_msg],
        req_start_date: Date.today + 30,
        req_days: 10,
        req_periodicity: "1 jour par semaine",
        req_description: "Le but de la mission est d'aider l'association grâce à mes compétences en #{user.candidate.function}"
      )
      approved_candidacies << candidacy
    end

    approved_candidacies.pop(pending_candidacy_count)

    approved_candidacies.each do |candidacy|
      candidacy.update(status: :mission, comments_attributes: [status: "mission", user_id: admin_user.id, content: "Votre candidature a été approuvée."])
      mission = Mission.create(
        title: "#{candidacy.beneficiary.name} - #{candidacy.offer.title}",
        start_date: Date.today + 30,
        end_date: Date.today + 120,
        periodicity: candidacy.req_periodicity,
        days_count: candidacy.req_days,
        description: candidacy.req_description,
        manager_approval: :approved,
        status: :draft,
        candidacy_id: candidacy.id
      )
      approved_missions << mission
    end

    approved_missions.pop.update(beneficiary_approval: :approved, draft_step: :validation, start_date: Date.today + 7)
    activated_mission = approved_missions.last
    activated_mission.update(beneficiary_approval: :approved, draft_step: :validation, status: :activated, start_date: Date.today - 25)

    Timesheet.create(
      mission_id: activated_mission.id,
      start_time: Date.today.to_datetime - 20 + Time.parse("09:00:00").seconds_since_midnight.seconds,
      end_time: Date.today.to_datetime - 20 + Time.parse("17:00:00").seconds_since_midnight.seconds
    )
  end

  def delete_demo_for(company)
    domain_format = "#{company.slug}-demain.works"
    demo_users = company.users.select{|u| u.email.slice(/@.+/)&.delete("@") == domain_format}
    demo_users.each{|user| user.destroy}
    demo_whitelists = company.whitelists.select{|wl| wl.input_format.slice(/@.+/)&.delete("@") == domain_format}
    demo_whitelists.each{|wl| wl.destroy}
    Whitelist.find_by(company_id: company.id, input_format: domain_format)&.destroy
  end

  def reset_demo_for(company)
    delete_demo_for(company)
    set_demo_for(company)
  end
end
