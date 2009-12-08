require 'spec_helper'

describe MessagesController do

  describe 'with anonymous user' do
    describe 'POST message' do
      describe 'WITH API_KEY valid' do
        before do
          @user = Factory(:user)
        end

        it 'should create a message' do
          lambda do
            post :create, :api_key => @user.id.to_s,
              :subject => 'a good subject',
                :body => 'a good body',
                :message_kinds => { '0' => {:channel => 'jabber',
                  :to => 'cyril.mougel@gmail.com'}}
          end.should change(Message, :count)
          response.should be_success
        end

      end

      describe 'with API_KEY unvalid' do

      end

      describe 'without API_KEY' do

      end
    end
  end

  describe 'with user logged' do
    describe 'POST' do
    end
  end

end
