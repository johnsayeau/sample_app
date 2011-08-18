# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'digest'

class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  #valdate presence oa a name
  validates :name, :presence => true,
                   :length => {:maximum => 50}

  validates :email, :presence => true,
                    :format => {:with => email_regex},
                    :uniqueness => {:case_sensitive => false}

  #automatically create the virtual attribute 'confirmation_password'
  validates :password,  :presence => true,
                        :confirmation => true,
                        :length => {:within => 6..40}

  before_save :encrypt_password

  def has_password?(submitted_password)
    #Return true if the user's password matches the submitted password
    #Compare the encrypted_password with the encrypted version of the submitted password

    self.encrypted_password == encrypt(submitted_password) #'self' is not needed here

  end

  def self.authenticate(email, submitted_password)
    user = User.find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
    #returns nil implicitly if password mismatch
  end

  private

  def encrypt_password
    self.salt= make_salt if new_record?
    self.encrypted_password = encrypt(password)
  end

  def encrypt(string)
    secure_hash("#{salt}--#{string}")
  end

  def make_salt
    secure_hash("#{Time.now.utc}--password")
  end

  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end
  
end
