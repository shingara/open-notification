class Jabbers < Application

  before :ensure_authenticated

  def index
    render
  end

  def new
    @jabber = Jabber.new
    display @jabber
  end

  def create
    jabber = Jabber.new(params[:jabber])
    jabber.save
    jabber.send_notification
    redirect resource(:jabbers, :new)
  end
  
end
