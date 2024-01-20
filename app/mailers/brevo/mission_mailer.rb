class Brevo::MissionMailer < Brevo::Mailer
  def self.awaiting_activation(mission)
    @template_id = 19
    @company = mission.candidacy.user.company
    @link = routes.company_admin_mission_url(
      subdomain: @company.slug,
      id: mission.id
      )
    set_admin_recipients
    set_admin_params
    @params[:beneficiary_name] = mission.beneficiary.name
    build_brevo_mail
  end

  def self.mission_activated(mission)
    @template_id = 18
    @user = mission.candidate.user
    @link = routes.user_mission_url(
      subdomain: @user.company.slug,
      id: mission.id
      )
    set_user_recipient
    set_params
    @params[:beneficiary_name] = mission.beneficiary.name
    build_brevo_mail
  end
end
