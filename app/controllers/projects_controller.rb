class ProjectsController < ApplicationController
  before_action :require_admin, only: [:destroy, :remand, :approve, :resume, :drop]
  before_action :set_project, only: [:show, :preview, :edit, :edit_rewards, :update, :destroy, :discard, :apply, :approve, :resume, :remand, :suspend, :drop, :complete, :cancel]
  before_action :require_login, except: [:index, :show]
  before_action :require_creator, only: [:discard, :apply, :suspend]
  before_action :require_creator_allowed, only: [:edit, :edit_rewards, :update]

  include AdaptivePayments

  # GET /projects
  def index
    @projects = Project.all.order(:id)
  end

  # GET /projects/1
  def show
  end

  # GET /projects/1/preview
  def preview
    @is_preview = true
    render :show
  end

  # GET /projects/start
  def start
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
    if @project.status_div_active?
      @project = @project.replicate
      @project.status_div = Divs::ProjectStatus::TEMP
      @project.save
    end
  end

  # GET /projects/1/edit_rewards
  def edit_rewards
  end

  # POST /projects
  def create
    @project = Project.new(project_params)
    @project.user = current_user
    @project.status_div = Divs::ProjectStatus::DRAFT

    return render :new unless @project.code_exists?

    if @project.save(validate: params[:save_draft].blank?)
      if params[:save_draft]
        redirect_to @project, notice: 'Draft was successfully saved.'
      elsif params[:edit_rewards]
        redirect_to edit_rewards_project_path(@project)
      end
    else
      render :new
    end
  end

  # PATCH/PUT /projects/1
  def update
    if params[:project].present?
      @project.assign_attributes(project_params)
    end

    if params[:preview]
      unless @project.rewards_exist
        return render :edit_rewards
      end
    end

    if @project.save(validate: params[:save_draft].blank?)
      if params[:edit_rewards]
        redirect_to edit_rewards_project_path(@project)
      elsif params[:save_draft]
        redirect_to @project, notice: 'Draft was successfully saved.'
      elsif params[:preview]
        redirect_to preview_project_path(@project)
      end
    else
      if params[:update_rewards]
        render :edit_rewards
      else
        render :edit
      end
    end
  end

  # GET /projects/1/discard
  def discard
    @project.discard!
    redirect_to projects_url, notice: 'Project was discarded.'
  end

  # GET /projects/1/apply
  def apply
    @project.apply!
    redirect_to @project, notice: 'Project was successfully applied.'
  end

  # GET /projects/1/remand
  def remand
    @project.remand!
    redirect_to @project, notice: 'Project was successfully remanded.'
  end

  # GET /projects/1/approve
  def approve
    @project.approve!
    redirect_to @project, notice: 'Project was successfully approved.'
  end

  # GET /projects/1/resume
  def resume
    @project.resume!
    redirect_to @project, notice: 'Project was successfully resumed.'
  end

  # GET /projects/1/suspend
  def suspend
    @project.suspend!
    redirect_to @project, notice: 'Project was successfully suspended.'
  end

  # GET /projects/1/drop
  def drop
    @project.drop!
    redirect_to projects_url, notice: 'Project was successfully dropped.'
  end

  # DELETE /projects/1
  def destroy
    @project.destroy
    redirect_to projects_url, notice: 'Project was successfully destroyed.'
  end

  # POST /project/1/complete
  def complete
    @project.pledges.each do |pledge|
      opts = { :email => 'shizuka.kakimoto-receiver@jepco.org', # 調達者のPayPalアカウントが入る
               :preapprovalKey => pledge.pledge_payment.preapproval_key,
               :amount => pledge.reward.price }

      pay = adaptive_payments_api.build_pay(approval_options(opts))
      pay_response = adaptive_payments_api.pay(pay)

      if pay_response.success? && pay_response.paymentExecStatus == EXEC_STATUS_COMPLETED
        pledge.approve!
        approve_log(pay_response, approval_options(opts))
      else
        pledge.pay_error!
        payment_error_log(pay_response)
      end
    end
  end

  # POST /project/1/cancel
  def cancel
    @project.pledges.each do |pledge|
      cancel_preapproval = adaptive_payments_api.
                             build_cancel_preapproval(cancel_preapproval_options(pledge.pledge_payment.preapproval_key))
      cancel_preapproval_response = adaptive_payments_api.cancel_preapproval(cancel_preapproval)

      if cancel_preapproval_response.success?
        pledge.cancel!
      else
        pledge.pay_error!
        payment_error_log(cancel_preapproval_response)
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = Project.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def project_params
    logger.debug(params)
    params[:project][:project_locales_attributes].try(:each) do |index, hash|
      if hash[:use_this_language] == "0"
        hash[:_destroy] = true
        params[:project][:project_headers_attributes][index][:_destroy] = true
        params[:project][:project_contents_attributes][index][:_destroy] = true
      end
      hash[:is_main] = hash[:language_id] == params[:project][:main_language_id]
    end
    params[:project][:rewards_attributes].try(:each) do |index, hash|
      if hash[:ships_to_div].to_i == Divs::RewardShipsTo::NO_SHIPPING
        hash[:default_shipping_rate] = nil
        hash[:reward_shippings_attributes].try(:each) { |i_rs, h_rs| h_rs[:_destroy] = true }
      elsif hash[:ships_to_div].to_i == Divs::RewardShipsTo::CERTAIN_COUNTRIES
        hash[:default_shipping_rate] = nil
      end
    end
    params.require(:project).permit(
      :id,
      :code,
      :category_id,
      :goal_amount,
      :duration_days,
      :applied_begin_date,
      project_locales_attributes: [
        :id,
        :language_id,
        :is_main,
        :use_this_language,
        :_destroy
      ],
      project_headers_attributes: [
        :id,
        :language_id,
        :image,
        :image_cache,
        :title,
        :_destroy
      ],
      project_contents_attributes: [
        :id,
        :language_id,
        :body,
        :_destroy
      ],
      rewards_attributes: [
        :id,
        :price,
        :count,
        :estimated_delivery,
        :ships_to_div,
        :default_shipping_rate,
        :_destroy,
        reward_shippings_attributes: [
          :id,
          :nation_id,
          :shipping_rate,
          :_destroy
        ],
        reward_contents_attributes: [
          :id,
          :language_id,
          :title,
          :image,
          :image_cache,
          :description,
          :_destroy
        ]
      ]
    )
  end

  # Filter: creator of the project
  def require_creator
    render_404 unless @project.user == current_user || is_admin?
  end

  # Filter: creator of the project and allowed to edit
  def require_creator_allowed
    return render_404 unless @project.user == current_user || is_admin?

    unless @project.status_div_draft? || @project.status_div_remanded? || @project.status_div_active? || @project.status_div_temp?
      redirect_to projects_url, alert: "This project is under #{@project.status_div.t}, then you cannot edit now."
    end
  end
end
