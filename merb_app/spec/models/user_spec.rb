require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe User do

  it "should be valid" do
    user_helper.save.should be_true
  end

  it 'should not valid if no login' do
    user_helper(:login => '').save.should_not be_true
  end

  it 'should not valid if no email' do
    user_helper(:email => '').save.should_not be_true
  end
end
