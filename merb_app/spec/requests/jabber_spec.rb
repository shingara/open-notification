require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "/jabber" do
  before(:each) do
    @response = request("/jabber")
  end
end