class CompanyAdmin::WhitelistsController < CompanyAdminController
  include ControllerUtilities

  before_action :set_tab, only: [:index]

  def new
    @whitelist = Whitelist.new
  end

  def upload
    require 'csv'
    @whitelist = Whitelist.new
    if params[:whitelist][:batch_file].nil?
      @whitelist.errors.add(:batch_file, "Fichier manquant")
      render :new, status: :unprocessable_entity
    else
      file = params[:whitelist][:batch_file]
      @array = []
      CSV.foreach(file.path, encoding: 'iso8859-1', headers: false) do |row|
        @array << row
      end
      @path = create_tempfile(file).path
      respond_to do |format|
        format.turbo_stream {render :batch_list}
      end
    end
  end

  def save_batch
    columns = params[:column_type].permit!.to_h
    @saved = []
    @fails = []
    file = CSV.open(params[:batch_list_path], encoding: 'iso8859-1', headers: false)
    headers = to_boolean(params[:headers]) ? file.first : false
    file.each do |row|
      unless row == headers
        wl = Whitelist.new(
          company_id: current_user.company.id,
          input_type: :email,
          input_format: row[columns.key("email").to_i],
          input_custom: row[columns.key("id").to_i]
        )
        wl.save ? @saved << wl : @fails << wl
      end
    end
    render :batch_result
  end

  def index
    set_whitelists
    @whitelist = Whitelist.new
  end

  def create
    @whitelist = Whitelist.new(whitelist_params)
    authorize @whitelist
    @whitelist.company = current_user.company
    @whitelist.input_type = "email"
    if @whitelist.save
      redirect_to company_admin_whitelists_path, status: :see_other
    else
      set_whitelists
      set_tab
      @error = true
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    @whitelist = Whitelist.find(params[:id])
    @whitelist.destroy
    redirect_to company_admin_whitelists_path, status: :see_other
  end

  private

  def set_whitelists
    @whitelists = policy_scope(Whitelist).order(created_at: :desc)
  end

  def whitelist_params
    params.require(:whitelist).permit(:input_format, :input_custom, :pre_approval)
  end

  def set_tab
    @tab = 2
  end

  def create_tempfile(file)
    tmpfile = Tempfile.new(['batch_upload', '.csv'])
    tmpfile.write(File.read(file.path))
    tmpfile.close
    tmpfile
  end
end
