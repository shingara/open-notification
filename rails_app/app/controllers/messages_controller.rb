class MessagesController < ApplicationController

  before_filter :authenticate_user_if_not_public_access

  def index
    @messages = current_user.messages.paginate(:order => 'created_at DESC',
                                              :per_page => 10,
                                              :page => (params[:page] || 1))
  end

  def new
    @message = Message.new
    @message.message_kinds.build
  end

  def create
    @message = Message.new(params[:message].merge(:from => current_user))
    if @message.save
      flash[:notice] = 'Notification send'
      redirect_to new_message_url
    else
      render :new
    end
  end

  private

  def authenticate_user_if_not_public_access
    if params[:api_key]
      session.user = User.get(params[:api_key])
      params[:message] = {}
      params[:message][:text] = params[:text]
      params[:message][:to] = params[:to]
    else
      authenticate_user!
    end
  end

end
