class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_time_zone
  before_action :set_locale

  # 例外ハンドル
  if !Rails.env.development?
    rescue_from Exception,                        with: :render_500
    rescue_from ActiveRecord::RecordNotFound,     with: :render_404
    rescue_from ActionController::RoutingError,   with: :render_404
  end

  def routing_error
    raise ActionController::RoutingError.new(params[:path])
  end

  def render_404(e = nil)
    logger.info "Rendering 404 with exception: #{e.message}" if e

    #binding.pry
    if request.xhr?
      render json: { error: '404 error' }, status: 404
    else
      format = params[:format] == :json ? :json : :html
      ## For customized template(views/errors/error_404.html.erb)
      # render template: 'errors/error_404', formats: format, 
      #   status: 404, layout: 'application', content_type: 'text/html'
      render file: Rails.root.join('public/404.html'), 
        status: 404, layout: false, content_type: 'text/html'
    end
  end

  def render_500(e = nil)
    logger.info "Rendering 500 with exception: #{e.message}" if e
    Airbrake.notify(e) if e # Airbrake/Errbitを使う場合はこちら

    if request.xhr?
      render json: { error: '500 error' }, status: 500
    else
      format = params[:format] == :json ? :json : :html
      ## For customized template(views/errors/error_505.html.erb)
      # render template: 'errors/error_500', formats: format, 
      #   status: 500, layout: 'application', content_type: 'text/html'
      render file: Rails.root.join('public/500.html'), 
        status: 500, layout: false, content_type: 'text/html'
    end
  end

  # override- set locale to all url
  def default_url_options(options = {})
    {locale: I18n.locale == I18n.default_locale ? nil : I18n.locale}.merge options
  end

  protected

  def is_admin?
    current_user && current_user.is_admin
  end

  def admin_required
    render_404 unless is_admin?
  end

  # Filter: admin user
  def require_admin
    render_404 unless logged_in? && current_user.is_admin
  end

  private

  # Callback of require_login
  def not_authenticated
    redirect_to login_path, alert: "Please login first"
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  # Set time zone to Time.zone
  def set_time_zone
    Time.zone = - cookies[:tzoffset].to_i / 60
  end
end
