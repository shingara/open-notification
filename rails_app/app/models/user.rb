class User

  include MongoMapper::Document

  devise :authenticatable

  key :login,  String , :unique => true
  key :email,  String
  key :firstname, String
  key :lastname, String
  key :global_admin, Boolean
  key :next_num_message, Integer

  many :messages, :foreign_key => 'from_id'

  validates_true_for :global_admin,
    :logic => lambda { allways_one_global_admin },
    :message => 'need a global admin'
  validates_presence_of :email
  validates_uniqueness_of :email

  def new_num_message
    old_num = next_num_message || 1
    self.next_num_message = old_num + 1
    save!
    old_num
  end

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
