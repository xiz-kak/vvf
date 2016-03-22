class UsersController < ApplicationController
  before_action :require_admin, only: [:index, :destroy]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :require_self, only: [:edit, :update, :destroy]

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

    if @user.save
      if current_user && current_user.is_admin
        redirect_to :users, notice: 'User was successfully created.'
      else
        auto_login(@user)
        redirect_to root_path, notice: 'User was successfully created.'
      end
    else
      render :new
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
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
