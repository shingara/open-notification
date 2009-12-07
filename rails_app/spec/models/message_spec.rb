require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Message do
  describe 'Factory' do
    it 'should be valid' do
      Factory(:message).should be_valid
    end
  end

  describe 'validations' do
    it "should not valid if no text" do
      Factory.build(:message, :body => '').should_not be_valid
    end

    it 'should not valid if no message_kinds' do
      Factory.build(:message, :message_kinds => []).should_not be_valid
    end

    it 'should not valid if message_kinds without to' do
      Factory.build(:message, :message_kinds => [Factory.build(:jabber, :to => '')]).should_not be_valid
    end
  end

  describe '#send_notification' do
    it 'should request nanite when message is create' do
      message = Factory.build(:message)
      jabber = message.message_kinds.first
      jabber.expects(:notification).with('/jabber_notification/notif', message.subject, message.body)
      message.save
    end
  end
end
