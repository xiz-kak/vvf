class UsersController < ApplicationController
  before_action :require_admin, only: [:index, :destroy]
  before_action :set_user, only: [:show, :edit, :update, :destroy, :profile]
  before_action :require_self, only: [:edit, :update, :destroy]

  # GET /users/1/activate
  def activate
    if (@user = User.load_from_activation_token(params[:id]))
      @user.activate!
      redirect_to login_path, notice: t('msg.user_activated')
    else
      not_authenticated
    end
  end

  # GET /profile/1
  def profile
    if logged_in? && @user == current_user
      redirect_to controller: :mypage, action: :profile
    else
      render :show
    end
  end

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if User.exists?(email: @user.email)
      u = User.find_by(email: @user.email)
      if u.external? || u.activation_state == 'active'
        return redirect_to login_path, notice: t('msg.account_exists')
      else
        User.where(email: @user.email).update_all(email: "#{Time.now.strftime('%Y%m%d-%H%M%S%3N')}-#{@user.email}")
      end
    end

    if @user.save
      if current_user && current_user.is_admin
        redirect_to :users, notice: t('msg.user_created')
      else
        redirect_to root_path, notice: t('msg.please_activate', email: @user.email)
      end
    else
      render :new
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      redirect_to @user, notice: t('msg.user_updated')
    else
      render :edit
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    redirect_to users_url, notice: t('msg.user_destroyed')
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name,
                                 :authentications_attributes)
  end

  # Filter: him/herself
  def require_self
    render_404 unless @user == current_user
  end
end
