
class User < CouchRest::ExtendedDocument

  property :email
  property :hashed_password
  property :salt
  property :permission_level

  view_by :email

  timestamps!

end
