class User < ApplicationRecord
  has_secure_password

  validates :username, :email, uniqueness: true
  validates :username, :password, :email, presence: true
  validates :email, email: true
  validates :password, length: { minimum: 6 }

end
