class CompanyUser::PagesController < CompanyUserController
before_action :set_tab, except: [:book_call, :no_mission]
before_action :verify_open_access, except: [:access_closed, :no_mission]

  def dashboard
    authorize :company_user_page
    @pending_selections = policy_scope(Candidacy).where(origin: [:admin, :company_admin], status: :selection, active: true)
    @pending_candidacies = policy_scope(Candidacy).where(active: true).where.not(status: :selection)
    if current_user.on_boarding_completed?
      render restrictable(:dashboard)
    else
      redirect_to user_onboarding_path
    end
  end

  def on_boarding
    authorize :company_user_page
    if !current_user.on_boarding_completed?
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

  def no_mission
    authorize :company_user_page
    if current_user.candidate.active_mission
      redirect_to user_mission_path(@active_engagement)
    else
      @tab = 5
    end
  end

  def info
    authorize :company_user_page
    @tab = "info"
  end

  def access_closed
    if !current_user.company.inactive_status?
      redirect_to root_path
    end
  end

  private

  def set_tab
    @tab = 0
  end

  def set_steps
    case
    when !current_user.candidate.profile_completed
      @active_step = 1
    when current_user.candidate.profile_completed && current_user.never_applied?
      @active_step = 2
    when current_user.last_employee_application.pending_status?
      @active_step = 3
    else
      @active_step = 4
    end
  end

  def restrictable(view)
    current_user.not_eligible? ? :access_restricted : view
  end

end
