desc "Resetting demo account and user data"
task reset_demo: :environment do

  slug = "demo"
  name = "MetalCo"
  domain = "metal.co"
  USERS = [
    User.new({first_name: "James", last_name: "Hetfield", company_role: "user"}), # demo user account
    User.new({first_name: "Corey", last_name: "Taylor", company_role: "user"}),
    User.new({first_name: "Jonathan", last_name: "Davis", company_role: "user"}),
    User.new({first_name: "Serj", last_name: "Tankian", company_role: "user"}),
    User.new({first_name: "Fred", last_name: "Durst", company_role: "user"}),
    User.new({first_name: "Chino", last_name: "Moreno", company_role: "user"}),
    User.new({first_name: "Max", last_name: "Cavalera", company_role: "admin"}) # demo admin account
  ]
  LYRICS = [
    "Gimme fuel gimme fire gimme, gimme that which I desire",
    "Did you never give a damn in the first place?",
    "Boom na da noom na nanema! Da boom na da noom na namena!",
    "Wake up! (wake up) Grab a brush and put a little make-up",
    "It's just one of those days when you don't wanna wake up",
    "Push back the square... Now that you need her",
    "Sepulnation!"
  ]

  oldco = Company.find_by_slug(slug)
  Cloudinary::Uploader.destroy("#{Rails.env}/#{oldco&.logo&.key}")
  oldco&.destroy

  company = Company.new({name: name, slug: "demo" })
  company.logo.attach(io: File.open('app/assets/images/heart_globe.png'), filename: 'demo_logo.png')

  if company.save
    p "#{company.name} created"
    OfferRule.create(company: company)
  else
    p "#{company.name} failed"
    p company
    p company.errors
    return
  end

  whitelist = Whitelist.new({input_type: "domain", input_format: domain, company_id: company.id, catch_all: true})
  if whitelist.save
    p "#{whitelist.input_format} domain added to #{company.name}"
  else
    p "whitelist domain creation failed"
    p whitelist
    p whitelist.errors
    return
  end

  def auto_email(user, whitelist)
    "#{user.first_name}.#{user.last_name}@#{whitelist.input_format}"
  end

  def punchline(user)
    i = USERS.find_index(user)
    return LYRICS[i]
  end

  def add_candidate_eligibility(user)
    candidate = Candidate.create(user: user, status: "Salarié.e")
    if user.company_user? && user.first_name != USERS[0][:first_name]
      candidate.update(profile_completed: true, call_status: "done")
      EmployeeApplication.create(
        candidate_id: candidate.id,
        motivation_msg: punchline(user),
        status: "approved")
    end
  end

  USERS.each do |user|
    user.email = auto_email(user, whitelist)
    user.password = ENV['DEMO_PASSWORD']
    user.company = company
    user.demo = true
    if user.save
      add_candidate_eligibility(user)
      p "OK : #{user.first_name} added as #{user.role}"
    else
      p "ERROR : #{user.first_name} failed"
      p user
      p user.errors
      return
    end
  end

  company.employee_applications.first.update({status: "pending"})
  EligibilityPeriod.create({title: "Année 2024", start_date: "01/11/2023".to_date, end_date: "31/12/2024".to_date, company_id: company.id})

  eligible_users = User.where(company_id: company.id, company_role: "user").where.not(first_name: USERS[0][:first_name]).select{|u| u.eligibility_on_going?}
  admin_user = User.find_by(company_id: company.id, company_role: "admin")
  offers_scope = Offer.where(status: "active", publish: true).where.not(title: "no_offer")

  eligible_users[0..-2].each do |user|
    candidacy = Candidacy.new(
      offer_id: offers_scope.sample.id,
      candidate_id: user.candidate.id,
      active: true,
      origin: "admin",
      motivation_msg: "Je souhaite candidater à cette mission",
      status: "mission",
      comments_attributes: [user: admin_user, content: "Vous êtes autorisé à effectuer cette mission"])
    if candidacy.save
      p "OK : #{user.first_name} applied at #{candidacy.offer.beneficiary.name}"
    else
      p "ERROR : #{user.first_name} failed"
      p candidacy
      p candidacy.errors
      return
    end
    mission = Mission.create(
      title: "#{candidacy.beneficiary.name} - #{candidacy.offer.title}",
      start_date: Date.today + 30,
      end_date: Date.today + 120,
      periodicity: "1 jour toutes les 2 semaines",
      days_count: 10,
      manager_approval: "approved",
      status: "draft",
      candidacy_id: candidacy.id)
    if mission.save
      p "OK : mission created for #{user.first_name}"
    else
      p "ERROR : #{user.first_name} failed"
      p mission
      p mission.errors
    end
  end

  pending_user = eligible_users.last

  bookmark = Candidacy.create(
    offer_id: offers_scope.sample.id,
    candidate_id: pending_user.candidate.id,
    active: true,
    origin: "company_user",
    status: "selection"
  )
  Candidacy.create(
    offer_id: offers_scope.where.not(id: bookmark.id).sample.id,
    candidate_id: pending_user.candidate.id,
    active: true,
    origin: "admin",
    status: "user_validation",
    comments_attributes: [status: "user_validation", user_id: pending_user.id, content: "Je souhaite candidater"],
    req_start_date: Date.today + 45,
    req_days: 12,
    req_periodicity: "1 jour par semaine",
    req_description: "Assister l'association sur une mission en lien avec mes nombreuses compétences"
  )

  questions = [
    ["Evaluer le contenu de la mission", "rating"],
    ["Commenter le contenu de la mission", "comment"],
    ["Evaluer l'encadrement de la mission par l'association", "rating"],
    ["Commenter l'encadremenet de la mission par l'association", "comment"],
    ["Souhaitez-vous présenter l'association en interne ?", "checkbox"]
  ]

  questions.each do |question|
    Question.create(title: question[0], input_type: question[1], company_id: company.id)
  end
end
