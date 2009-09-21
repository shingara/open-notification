require 'lib/couchrest_salted_user.rb'
class User < CouchRest::ExtendedDocument

  include CouchRest::Validation
  extend Merb::Authentication::Mixins::SaltedUser::CouchRestClassMethods

  property :login
  property :email

  key :login, String, :required => true
  key :email, String, :required => true

  many :jabbers, :foreign_key => 'from_id'

  timestamps!

  def last_jabbers(pagination)
    jabbers.paginate(pagination)
  end

end
