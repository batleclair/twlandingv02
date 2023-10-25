class Admin::CandidaciesController < AdminController
before_action :set_candidacy, except: [:new, :create, :index]
before_action :set_comments, except: [:new, :create, :index]

  def index
    @candidacies = policy_scope(Candidacy).order(created_at: :desc)
  end

  def new
    @candidacy = Candidacy.new
    @candidates = policy_scope(Candidate).select{|c| c.user.last_employee_application&.approved_status?}
    @offers = Offer.all
  end

  def create
    @candidacy = Candidacy.new(candidacy_params)
    @candidacy.assign_attributes(status: "selection", origin: "admin", active: true)
    if @candidacy.save
      redirect_to admin_candidacies_path
    else
      @candidates = policy_scope(Candidate).select{|c| c.user.last_employee_application&.approved_status?}
      @offers = Offer.all
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @comment = Comment.new
  end

  def edit
  end

  def update
    @candidacy.update(candidacy_params)
    @candidacy.comments.each{ |c| c.marked_for_destruction? }
    if @candidacy.save
      redirect_to admin_candidacy_path(@candidacy)
    else
      @comment = @candidacy.comments.last
      render :show, status: :unprocessable_entity
    end
  end

  def destroy
    @candidacy.destroy
    redirect_to admin_candidacies_path, status: :see_other
  end

  private

  def set_candidacy
    @candidacy = Candidacy.find(params[:id])
    authorize @candidacy
  end

  def set_comments
    @comments = Candidacy.find(params[:id]).comments
  end

  def candidacy_params
    params.require(:candidacy).permit(
      :active,
      :status,
      :offer_id,
      :candidate_id,
      comments_attributes: [:content, :id, :_destroy, :user_id]
    )
  end

end
