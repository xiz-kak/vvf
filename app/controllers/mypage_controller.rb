class MypageController < ApplicationController
  before_action :require_login
  before_action :set_user

  def profile
  end

  def notifications
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = current_user
    end
end
