class Message

  include MongoMapper::Document

  key :subject, String
  key :body, String, :required => true
  key :from_id, ObjectId, :required => true
  key :num, Integer, :required => true

  timestamps!

  belongs_to :from, :class_name => 'User'
  has_many :message_kinds

  before_validation :define_num

  after_create :send_notification

  validates_true_for :message_kinds,
    :logic => lambda { not message_kinds.empty? },
    :message => 'need recipients'
  include_errors_from :message_kinds

  def message_kinds_attributes=(attributes)
    attributes.each do |index, value|
      message_kinds.build(value)
    end
  end

  def send_notification
    message_kinds.each do |m|
      m.send_notification
    end
  end

  # get number of this message for this user
  def define_num
    self.num ||= from.new_num_message
  end


end
