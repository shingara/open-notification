class JabbersController < ApplicationController

  before_filter :authenticate_user_if_not_public_access

  def index
    @jabbers = current_user.jabbers.paginate(:order => 'created_at DESC',
                                             :per_page => 10,
                                             :page => (params[:page] || 1))
  end

  def new
    @jabber = Message.new
  end

  def create
    @jabber = Message.new(params[:jabber].merge(:from => current_user))
    if @jabber.save
      flash[:notice] = 'Jabber notification send'
      redirect_to new_jabber_url
    else
      render :new
    end
  end

  private

  def authenticate_user_if_not_public_access
    if params[:api_key]
      session.user = User.get(params[:api_key])
      params[:jabber] = {}
      params[:jabber][:to] = params[:to]
      params[:jabber][:text] = params[:text]
    else
      authenticate_user!
    end
  end

end
