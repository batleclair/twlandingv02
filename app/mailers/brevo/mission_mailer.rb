class Brevo::MissionMailer < Brevo::Mailer
  def self.mission_activated(mission)
    @template_id = 18
    @user = mission.candidate.user
    @link = routes.user_mission_url(
      subdomain: @user.company.slug,
      id: mission.id
      )
    set_params
    @params[:beneficiary_name] = mission.beneficiary.name
    build_brevo_mail
  end
end
