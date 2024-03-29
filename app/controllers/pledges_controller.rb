class PledgesController < ApplicationController
  before_action :require_admin, only: [:destroy, :pay, :pay_back]
  before_action :set_pledge, only: [:show, :edit, :update, :destroy, :complete, :cancel, :pay, :pay_back]
  before_action :require_login, except: [:index, :show]
  before_action :require_backer, only: [:edit, :update]

  include AdaptivePayments

  # GET /pledges
  def index
    if params[:project_code]
      @project = Project.find_by(code: params[:project_code])
      if @project.present? && (is_admin? || @project.user == current_user)
        @pledges = Project.find_by(code: params[:project_code]).pledges
      end
    end

    if @pledges.blank?
      if is_admin?
        @pledges = Pledge.sorted
      else
        return render_404 if @pledges.blank?
      end
    end
  end

  # GET /pledges/1
  def show
  end

  # GET /rewards/1/new_pledge
  def new
    @pledge = Pledge.new(reward_code: params[:reward_code])
    @pledge.build_pledge_payment
    @pledge.build_pledge_shipping

    @pledge.pledge_payment.amount = @pledge.reward.price
    @pledge.pledge_payment.shipping_rate = 0
    @pledge.pledge_payment.total_amount = @pledge.reward.price

    render partial: 'form_for_modal'
  end

  # GET /pledges/1/edit
  def edit
    if !is_admin? && @pledge.pledge_payment.status != Divs::PledgePaymentStatus::UNPAID
      return redirect_to @pledge, alert: t('msg.payment_proceeded')
    end
  end

  # POST /pledges
  def create
    @pledge = Pledge.new(pledge_params)

    unless @pledge.reward.can_pledge_more?
      flash.now[:danger] = t('msg.reward_all_gone')
      return render :new
    end

    @pledge.user = current_user
    @pledge.pledged_at = Time.now

    if Rails.env.production?
      return redirect_to :back, alert: 'Vin-Vin Funding is still in Beta version. Pledge will be available after July.'
    end

    if @pledge.save
      if preapprove(@pledge)
        # redirected already to somewhere inside paypal
      else
        flash[:danger] = t('msg.preapproval_failed')
        redirect_to @pledge.reward.project
      end
    else
      flash.now[:danger] = t('msg.pledge_save_failed')
      render :new
    end
  end

  # PATCH/PUT /pledges/1
  def update
    if @pledge.pledge_payment.status != Divs::PledgePaymentStatus::UNPAID
      return redirect_to :back, alert: t('msg.payment_proceeded')
    end

    if @pledge.update(pledge_params)
      if preapprove(@pledge)
        # redirected already to somewhere inside paypal
      else
        flash[:danger] = t('msg.preapproval_failed')
        redirect_to @pledge.reward.project
      end
    else
      flash.now[:danger] = t('msg.pledge_save_failed')
      render :edit
    end
  end

  # DELETE /pledges/1
  def destroy
    @pledge.destroy
    redirect_to pledges_url, notice: t('msg.pledge_destroyed')
  end

  # GET /pledges/1/pay
  def pay
    payable_status = []
    payable_status << Divs::PledgePaymentStatus::PREAPPROVED
    payable_status << Divs::PledgePaymentStatus::PAY_BACK_ERROR
    payable_status << Divs::PledgePaymentStatus::PAY_ERROR

    if payable_status.include?(@pledge.pledge_payment.status)
      if pay_to_creator(@pledge)
        flash[:success] = t('msg.payment_completed')
      else
        flash[:danger] = t('msg.payment_failed')
      end
    else
      flash[:danger] = t('msg.not_payable_status', status: @pledge.pledge_payment.status.t)
    end
    redirect_to action: :index
  end

  # GET /pledges/1/pay_back
  def pay_back
    payable_status = []
    payable_status << Divs::PledgePaymentStatus::PREAPPROVED
    payable_status << Divs::PledgePaymentStatus::PAY_BACK_ERROR
    payable_status << Divs::PledgePaymentStatus::PAY_ERROR

    if payable_status.include?(@pledge.pledge_payment.status)
      if pay_back_to_backer(@pledge)
        flash[:success] = t('msg.back_payment_completed')
      else
        flash[:danger] = t('msg.back_payment_failed')
      end
    else
      flash[:danger] = t('msg.not_back_payable_status', status: @pledge.pledge_payment.status.t)
    end
    redirect_to action: :index
  end

  # GET /pledges/1/complete
  def complete
    @pledge.preapprove!

    ProjectPledgeSummary.pledge(@pledge.reward.project.code, @pledge.pledge_payment.amount)
    RewardPledgeSummary.pledge(@pledge.reward.code)

    project = @pledge.reward.project
    flash[:info] = t('msg.pledge_successful')
    redirect_to project
  end

  # GET /pledges/1/cancel
  def cancel
    project = @pledge.reward.project

    flash[:info] = t('msg.pledge_canceled')
    redirect_to project
  end

  # POST rewards/1/shipping_rate
  def shipping_rate
    sr = Reward.find_by(code: params[:reward_code]).shipping_rate(params[:nation_id])
    render json: sr
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_pledge
    @pledge = Pledge.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def pledge_params
    params.require(:pledge).permit(
      :reward_code,
      pledge_payment_attributes: [
        :id,
        :payment_method_div,
        :payment_vendor_id,
        :preapproval_key,
        :status
      ],
      pledge_shipping_attributes: [
        :id,
        :first_name,
        :last_name,
        :nation_id,
        :tel,
        :zip_code,
        :address1,
        :address2,
        :address3,
        :address4
      ]
    )
  end

  def require_backer
    return render_404 unless @pledge.user == current_user || is_admin?
  end
end
