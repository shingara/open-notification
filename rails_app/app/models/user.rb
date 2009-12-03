class User

  include MongoMapper::Document

  devise :authenticatable


  key :login,  String , :unique => true
  key :email,  String
  key :firstname, String
  key :lastname, String
  key :global_admin, Boolean

  many :jabbers, :foreign_key => 'from_id'

  validates_true_for :global_admin,
    :logic => lambda { allways_one_global_admin },
    :message => 'need a global admin'
  validates_presence_of :email
  validates_uniqueness_of :email

  private

  def allways_one_global_admin
    if User.count == 0
      self.global_admin = true
      return true
    end
    unless self.global_admin
      if User.first(:conditions => {:_id => {'$ne' => self._id},
                                    :global_admin => true}) == nil
        return false
      end
    end
    return true
  end

end
