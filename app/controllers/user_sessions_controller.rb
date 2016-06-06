class UserSessionsController < ApplicationController

  def new
    @user = User.new
  end

  def create
    if @user = login(params[:email], params[:password])
      redirect_back_or_to(root_path, info: t('msg.login_successful'))
    else
      flash.now[:danger] = t('msg.login_failed')
      render action: 'new'
    end
  end

  def destroy
    logout
    redirect_to root_path, notice: t('msg.logout_successful')
  end
end
