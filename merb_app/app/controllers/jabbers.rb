class Jabbers < Application

  before :ensure_authenticated, :unless => :public_access

  def index
    #really wiered if descending=false need :startkey.
    #if descending=true need :endkey
    @jabbers = Jabber.by_from(:endkey => [session.user.id], :descending => true)
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
