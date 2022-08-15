class User < ApplicationRecord
  before_save{email.downcase!}

  validates :name, presence: true,
    length: {maximum: Settings.validate.length.length_50}

  validates :email, presence: true,
    length: {maximum: Settings.validate.length.length_255},
    format: {with: Settings.validate.valid_email_regex},
    uniqueness: true

  validates :password, presence: true,
    length: {minimum: Settings.validate.length.length_6}

  has_secure_password
end
