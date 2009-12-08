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

    it 'should not valid if no IP' do
      Factory.build(:message, :ip => '').should_not be_valid
    end

    it 'should not valid with a bad IP format' do
      Factory.build(:message, :ip => 'an ip').should_not be_valid
    end

    it 'should not valid if ip already override his hour quota' do
      configatron.limit.ip.by_hour = 3
      3.of { Factory(:message, :ip => '192.168.0.1') }
      Factory.build(:message, :ip => '192.168.0.1').should_not be_valid
    end

    it 'should not valid if ip already override his month quota'
    it 'should not valid if user already override hist hour quota'
    it 'should not valid if user already override hi month quota'

  end

  describe '#send_notification' do
    it 'should request nanite when message is create' do
      message = Factory.build(:message)
      jabber = message.message_kinds.first
      jabber.expects(:notification).with('/jabber_notification/notif', message.subject, message.body)
      message.save
    end
  end

  describe 'callback' do
    it 'should increment num message with new message on same from' do
      user = Factory(:user)
      message_1 = Factory(:message, :from_id => user.id)
      message_1.num.should == 1
      message_2 = Factory(:message, :from_id => user.id)
      message_2.num.should == 2
    end

    it 'should not increment data if message not save because invalid' do
      pending
      # TODO: search how made an copy it to oupsnow
      user = Factory(:user)
      Factory.build(:message, :body => '', :from_id => user.id).save
      message_1 = Factory(:message, :from_id => user.id)
      user = user.reload
      user.messages.size.should == 1
      message_1.num.should == 1
    end

    it 'should not increment value num if other from' do
      user_1 = Factory(:user)
      message_1 = Factory(:message, :from_id => user_1.id)
      message_1.num.should == 1
      user_2 = Factory(:user)
      message_2 = Factory(:message, :from_id => user_2.id)
      message_2.num.should == 1
    end
  end
end
