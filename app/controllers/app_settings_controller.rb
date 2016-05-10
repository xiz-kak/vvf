class AppSettingsController < ApplicationController
  before_action :set_app_setting, only: [:show, :edit, :update]

  # GET /app_settings
  def index
    @app_settings = AppSetting.all
  end

  # GET /app_settings/1
  def show
  end

  # GET /app_settings/1/edit
  def edit
  end

  # PATCH/PUT /app_settings/1
  def update
    if @app_setting.update(app_setting_params)
      redirect_to @app_setting, notice: 'App setting was successfully updated.'
    else
      render :edit
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app_setting
      @app_setting = AppSetting.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def app_setting_params
      params.require(:app_setting).permit(:value)
    end
end
