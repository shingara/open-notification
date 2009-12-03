require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe User do

  it "should be valid if admin global" do
    Factory(:admin).should be_valid
  end

  it 'should not valid if global_admin is false but no user global_admin' do
    u = Factory(:admin)
    u.global_admin = false
    u.should_not be_valid
  end

  it 'should valid with global_admin false because already user global_admin' do
    Factory(:admin)
    Factory(:user).should be_valid
  end

  it 'should not put himself like global_admin false if you are the alone global_admin' do
    Factory(:admin)
    u = User.first
    u.global_admin = false
    u.should_not be_valid
  end

  it 'should first user can be create and define like global_admin' do
    u = User.new(:login => 'shingara',
             :email => 'cyril.mougel@gmail.com',
             :password => 'tintinpouet',
             :password_confirmation => 'tintinpouet')
    u.save.should be_true
    u.global_admin.should be_true
  end

  it 'should not valid if same login' do
    u = Factory(:user)
    Factory.build(:user, :login => u.login).should_not be_valid
  end

  it 'should not valid if same email' do
    u = Factory(:user)
    Factory.build(:user, :email => u.email).should_not be_valid
  end

  it 'should not valid if no email' do
    Factory.build(:user, :email => '').should_not be_valid
  end

end
