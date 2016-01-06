class User < ActiveRecord::Base
  LOOSE_EMAIL_REGEX = /\A(?<user>[^@\s]+)@(?<domain>(?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  has_many :credit_lines

  validates :email, format: { with: LOOSE_EMAIL_REGEX, message: 'valid email required' }
end
