require 'lib/couchrest_salted_user.rb'
class User < CouchRest::ExtendedDocument

  include CouchRest::Validation
  extend Merb::Authentication::Mixins::SaltedUser::CouchRestClassMethods

  property :login
  property :email

  view_by :email
  view_by :login

  timestamps!

end
