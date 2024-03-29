# == Schema Information
#
# Table name: users
#
#  id                              :integer          not null, primary key
#  email                           :string           not null
#  crypted_password                :string
#  salt                            :string
#  created_at                      :datetime
#  updated_at                      :datetime
#  name                            :string
#  is_admin                        :boolean          default(FALSE)
#  activation_state                :string
#  activation_token                :string
#  activation_token_expires_at     :datetime
#  reset_password_token            :string
#  reset_password_token_expires_at :datetime
#  reset_password_email_sent_at    :datetime
#
# Indexes
#
#  index_users_on_activation_token      (activation_token)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token)
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

  def uses_twitter?
    authentications.exists?(provider: :twitter)
  end

  def uses_facebook?
    authentications.exists?(provider: :facebook)
  end

  private

  def unique_email
    errors.add(:email, 'already exists') if User.exists?(email: read_attribute(:email))
  end
end
