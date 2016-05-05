# == Schema Information
#
# Table name: users
#
#  id               :integer          not null, primary key
#  email            :string           not null
#  crypted_password :string
#  salt             :string
#  created_at       :datetime
#  updated_at       :datetime
#  name             :string
#  is_admin         :boolean          default(FALSE)
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#

class User < ActiveRecord::Base
  authenticates_with_sorcery!

  has_many :authentications, :dependent => :destroy
  has_many :projects, :dependent => :destroy

  accepts_nested_attributes_for :authentications

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
  validate :unique_email, if: -> { new_record? }
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes["password"] }
  validates :password, confirmation: true, if: -> { new_record? || changes["password"] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes["password"] }

  include Encryptor

  def uses_twitter?
    authentications.exists?(provider: :twitter)
  end

  def uses_facebook?
    authentications.exists?(provider: :facebook)
  end

  def email=(val)
    write_attribute(:email, encrypt(val))
  end

  def email
    decrypt(read_attribute(:email)) if read_attribute(:email).present?
  end

  private

  def unique_email
    errors.add(:email, 'already exists') if User.exists?(email: read_attribute(:email))
  end
end
