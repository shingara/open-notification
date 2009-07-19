require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Jabber do

  it "should be valid" do
    jabber_helper.save.should be_true
  end

  it 'should not valid if no to' do
    jabber_helper(:to => '').save.should_not be_true
  end

  it 'should not valid if no text' do
    jabber_helper(:text => '').save.should_not be_true
  end
end
