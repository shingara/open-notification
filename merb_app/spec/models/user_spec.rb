require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe User do

  def user(params={})
    User.new({:login => /\w+/.gen,
             :email => "#{/\w+/.gen}.#{/\w+/.gen}@gmail.com",
             :password => 'notification',
             :password_confirmation => 'notification'}.merge(params))

  end

  it "should be valid" do
    user.save.should be_true
  end

  it 'should not valid if no login' do
    user(:login => '').save.should_not be_true
  end

  it 'should not valid if no email' do
    user(:email => '').save.should_not be_true
  end
end
