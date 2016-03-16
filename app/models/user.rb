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

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes["password"] }
  validates :password, confirmation: true, if: -> { new_record? || changes["password"] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes["password"] }
  validates :email, uniqueness: true

  def uses_twitter?
    authentications.exists?(provider: :twitter)
  end

  def uses_facebook?
    authentications.exists?(provider: :facebook)
  end

  def email=(val)
    write_attribute(:email, encryptor.encrypt_and_sign(val))
  end

  def email
    encryptor.decrypt_and_verify(read_attribute(:email)) if read_attribute(:email).present?
  end

  private

  def encryptor
    ActiveSupport::MessageEncryptor.new(ENV['ENCRYPTOR_KEY'])
  end
end
