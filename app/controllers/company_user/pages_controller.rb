class CompanyUser::PagesController < CompanyUserController

  def dashboard
    authorize :company_user_page
    if on_boarding_completed?
      render restrictable(:dashboard)
    else
      redirect_to user_onboarding_path
    end

  end

  def on_boarding
    authorize :company_user_page
    if !on_boarding_completed?
      set_steps
      render restrictable(:on_boarding)
    else
      redirect_to root_path
    end
  end

  def book_call
    authorize :company_user_page
    current_user.candidate.call_status_booked!
  end

  private

  def on_boarding_completed?
    !current_user.never_applied? &&
    current_user.candidate.profile_completed &&
    !current_user.candidate.call_status_pending?
  end

  def set_steps
    @step_1_status = "Votre équipe doit valider que votre situation vous permet de vous engager"
    @step_2_status = "Vous devez d'abord envoyer votre demande à l'administrateur"
    @step_3_status = "Vous devez d'abord #{"valider votre demande et " if current_user.eligibility != "approved"}compléter votre profil"
    case
    when current_user.never_applied?
      @active_step = 1
    when !current_user.never_applied? && !current_user.not_eligible? && !current_user.candidate.profile_completed
      @active_step = 2
      @step_1_status = step_1_output
      @step_2_status = "Vous pouvez désormais compléter votre profil"
      @step_3_status.delete("et compléter votre profil") if current_user.candidate.profile_completed
    else
      @active_step = 3
      @step_1_status = step_1_output
      @step_2_status = "Votre profil est complet 💪"
      @step_3_status = current_user.eligibility == "approved" ? "Vous pouvez désormais réserver un call avec votre conseiller Demain !" : "Vous devez attendre que votre demande soit validée"
    end
  end


  def step_1_output
    case current_user.last_employee_application.status
    when "pending"
      "⏳ Votre demande est en cours de validation par l'administrateur"
    when "approved"
      "🙌 Votre demande a été validée par l'administrateur"
    when "rejected"
      "😢 Votre demande a été refusée par l'administrateur"
    end
  end

  def restrictable(view)
    current_user.not_eligible? ? :restricted : view
  end

end
