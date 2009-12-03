require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Jabber do
  describe 'Factory' do
    it 'should be valid' do
      Factory(:jabber).should be_valid
    end
  end

  describe 'validations' do
    ['to', 'text'].each do |attr|
      it "should not valid if no #{attr}" do
        Factory.build(:jabber, attr.to_sym => '').should_not be_valid
      end
    end
  end
end
