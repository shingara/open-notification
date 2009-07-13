require 'couchrest'
SERVER = CouchRest.new
SERVER.default_database = 'jabber-notification'
require 'include/authenticated_system'

class User < CouchRest::ExtendedDocument

  include Sinatra::LilAuthentication::AuthenticatedSystem

  use_database SERVER.default_database

  property :email
  property :hashed_password
  property :salt
  property :permission_level

  view_by :email

  timestamps!

  def self.get_by_email(email)
    self.by_email(:key => email).first
  end

end
