require 'lib/couchrest_salted_user.rb'
class User < CouchRest::ExtendedDocument

  include CouchRest::Validation
  extend Merb::Authentication::Mixins::SaltedUser::CouchRestClassMethods

  property :login
  property :email

  view_by :email
  view_by :login

  timestamps!

  validates_present :login
  validates_present :email
  validates_present :crypted_password

  # if descending=true need inverse startkey and endkey. Cf documentation
  # http://wiki.apache.org/couchdb/HTTP_view_API#view_parameters
  def last_jabbers(paginate={})
    Jabber.by_from(:endkey => [self.id], 
                   :startkey => [self.id, {}], 
                   :descending => true).paginate(paginate.merge(
                     :total => jabbers_count))
  end

  def jabbers_count
    j = Jabber.by_count_from(
      :key => self.id, 
      :reduce => true)['rows'][0]
    j ? j["value"] : 0
  end

end
