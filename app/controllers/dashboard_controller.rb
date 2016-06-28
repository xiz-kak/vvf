class DashboardController < ApplicationController
  before_action :require_login
  before_action :set_target_project, except: [:index]

  def index
    p = Project.active.where(user_id: current_user.id).order(end_at: :DESC).first
    if p.present?
      return redirect_to action: :analytics, id: p.id
    end
  end

  def analytics
  end

  def notifications
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_target_project
      @project = Project.find(params[:id])
    end
end
