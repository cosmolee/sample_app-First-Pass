# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation
  has_secure_password
  #Validations for presence of password, confirmation of password (using a "password_confirmation" attribute) are automatically added. 
  #You can add more validations by hand if need be.

  has_many :microposts, dependent: :destroy

  before_save :create_remember_token

  validates :name,  presence: true, length: { maximum: 50 }
  valid_email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, 
                    format: { with: valid_email_regex },
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }

#10.37
    # This is preliminary. See "Following users" for the full implementation.
  def feed
    Micropost.where("user_id = ?", id)
  end

  # ...equivalent to
  #def feed
  #  microposts
  #end



  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end

end
