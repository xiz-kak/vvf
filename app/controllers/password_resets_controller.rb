class PasswordResetsController < ApplicationController

  def new
  end

  # request password reset.
  # you get here when the user entered his email in the reset password form and submitted it.
  def create
    @user = User.find_by_email(params[:email])

    if @user.blank?
      return redirect_to(new_password_reset_path, :notice => t('msg.email_not_exists'))
    end

    # This line sends an email to the user with instructions on how to reset their password (a url with a random token)
    if @user.deliver_reset_password_instructions!

      # Tell the user instructions have been sent whether or not email was found.
      # This is to not leak information to attackers about which emails exist in the system.
      redirect_to(root_path, :notice => t('msg.instructions_sent_email', email: @user.email))
    else
      redirect_to(root_path, :notice => t('msg.email_sent_failed'))
    end
  end

  # This is the reset password form.
  def edit
    @token = params[:id]
    @user = User.load_from_reset_password_token(params[:id])

    if @user.blank?
      not_authenticated
      return
    end
  end

  # This action fires when the user has sent the reset password form.
  def update
    @token = params[:id]
    @user = User.load_from_reset_password_token(params[:id])

    if @user.blank?
      not_authenticated
      return
    end

    # the next line makes the password confirmation validation work
    @user.password_confirmation = params[:user][:password_confirmation]
    # the next line clears the temporary token and updates the password
    if @user.change_password!(params[:user][:password])
      redirect_to(login_path, :notice => t('msg.password_updated'))
    else
      render :action => "edit"
    end
  end
end
