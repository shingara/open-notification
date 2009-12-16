class Message

  include MongoMapper::Document

  key :subject, String
  key :body, String, :required => true
  key :from_id, ObjectId, :required => true, :index => true
  key :num, Integer, :required => true
  key :ip, String, :required => true, :index => true # The ip to propose this message
  key :content_type, String

  timestamps!
  ensure_index :created_at

  validates_format_of :ip, :with => /\d+\.\d+\.\d+\.\d+/
  validates_true_for :ip,
    :logic => lambda { overflow_quota },
    :message => "you are over quota"

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

  def overflow_quota
    configatron.limit.ip.by_hour > Message.count(:ip => self.ip, :created_at.gt => 1.hour.ago.time) &&
    configatron.limit.ip.by_month > Message.count(:ip => self.ip, :created_at.gt => 1.month.ago.time) &&
    configatron.limit.user.by_hour > Message.count(:from_id => self.from_id, :created_at.gt => 1.hour.ago.time) &&
    configatron.limit.user.by_month > Message.count(:from_id => self.from_id, :created_at.gt => 1.month.ago.time)
  end


end
