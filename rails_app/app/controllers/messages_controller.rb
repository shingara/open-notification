class MessagesController < ApplicationController

  before_filter :authenticate_user_if_not_public_access
  skip_before_filter :verify_authenticity_token, :if => lambda{ params[:api_key] }


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
    @message.ip = request.remote_ip
    if @message.save
      if params[:api_key]
        render :text => ['success'].to_json, :status => 200
      else
        flash[:notice] = 'Notification send'
        redirect_to new_message_url
      end
    else
      render :new
    end
  end

  private

  def authenticate_user_if_not_public_access
    if params[:api_key]
      self.sign_in(User.find(params[:api_key]))
      params[:message] = {}
      params[:message][:body] = params[:body]
      params[:message][:subject] = params[:subject]
      params[:message][:message_kinds_attributes] = {}
      params[:message_kinds].each do |index, kinds|
        params[:message][:message_kinds_attributes][index] = {}
        params[:message][:message_kinds_attributes][index][:channel] = kinds[:channel]
        params[:message][:message_kinds_attributes][index][:to] = kinds[:to]
      end
    else
      authenticate_user!
    end
  end

end
