class Jabbers < Application

  before :ensure_authenticated, :unless => :public_access

  def index
    @jabbers = session.user.last_jabbers(:per_page => 10, :page => (params[:page] || 1))
    render
  end

  def new
    @jabber = Jabber.new
    display @jabber
  end

  def create
    @jabber = Jabber.new(params[:jabber].merge(:from => session.user.id))
    if @jabber.save
      @jabber.send_notification
      redirect resource(:jabbers, :new)
    else
      render :new
    end
  end

  private

  def public_access
    if params[:api_key]
      session.user = User.get(params[:api_key])
      params[:jabber] = {}
      params[:jabber][:to] = params[:to]
      params[:jabber][:text] = params[:text]
    end
  end
  
end
