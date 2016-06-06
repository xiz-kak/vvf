class OauthsController < ApplicationController
  # sends the user on a trip to the provider,
  # and after authorizing there back to the callback url.
  def oauth
    login_at(params[:provider])
  end

  def callback
    provider = auth_params[:provider]

    begin
      if logged_in?
        if @user = add_provider_to_user(provider)
          redirect_back_or_to root_path, notice: t('msg.login_external_successful', provider: provider.titleize)
        else
          redirect_back_or_to root_path, alert: t('msg.login_external_failed', provider: provider.titleize)
        end
      else
        if @user = login_from(provider)
          redirect_to root_path, notice: t('msg.login_external_successful', provider: provider.titleize)
        else
          @user = create_from(provider)
          # NOTE: this is the place to add '@user.activate!'
          # if you are using user_activation submodule

          reset_session # protect from session fixation attack
          auto_login(@user)
          redirect_to root_path, notice: t('msg.login_external_successful', provider: provider.titleize)
        end
      end
    rescue
      redirect_to root_path, alert: t('msg.login_external_failed', provider: provider.titleize)
    end
  end

  private

  def auth_params
    params.permit(:code, :provider)
  end
end
