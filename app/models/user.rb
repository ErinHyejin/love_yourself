require 'bcrypt'

class User < ActiveRecord::Base
  validates :email, format: {with:/[\w\-_]+@\w+[\.\w]+/, message:"organizer_mail should have '@', and '.'"}
   validates :name, :email, :password, presence: true
  has_many :todos
  # users.password_hash in the database is a :string
  include BCrypt

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def authenticate(password)
    self.password == password
  end
end
