class User < ActiveRecord::Base
  include SluggableLexSep

  has_many :posts, foreign_key: :user_id
  has_many :comments, foreign_key: :user_id
  has_many :votes, foreign_key: :user_id

  has_secure_password validations: false

  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, on: :create, length: {minimum: 5}

  sluggable_column :username
  def admin?
    self.role != nil && self.role.downcase == 'admin'
  end

  def moderator?
    self.role != nil && self.role.downcase == 'moderator'
  end

  def two_factor_auth?
    !self.phone.blank?
  end

  def generate_pin!
    self.update_column(:pin, rand(10**6))
  end

  def remove_pin!
    self.update_column(:pin, nil)
  end

  def send_pin_to_twilio
    msg='Please provide the pin to input login: #{self.pin}'
    # put your own credentials here
    account_sid = 'AC3a39baf17b1691bb1ea61f605952638b'
    auth_token = 'aeb63e6e0ea0eac34f989e7ca280b50f'

    # set up a client to talk to the Twilio REST API
    client = Twilio::REST::Client.new account_sid, auth_token

    client.account.messages.create({
      :from => '+16094546190',
      :to => '+919007110250',
      :body => msg
    })
  end

end