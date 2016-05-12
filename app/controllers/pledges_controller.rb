class PledgesController < ApplicationController
  before_action :require_admin, only: [:destroy]
  before_action :set_pledge, only: [:show, :edit, :update, :destroy, :complete, :cancel]
  before_action :require_login, except: [:index, :show]
  before_action :require_backer, only: [:edit, :update]

  include AdaptivePayments

  # GET /pledges
  def index
    @pledges = Pledge.all
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
      return redirect_to @pledge, alert: 'This payment is proceeded. You cannot modify.'
    end
  end

  # POST /pledges
  def create
    @pledge = Pledge.new(pledge_params)

    unless @pledge.reward.can_pledge_more?
      flash.now[:danger] = 'Sorry. This reward is all gone...'
      return render :new
    end

    @pledge.user = current_user
    @pledge.pledged_at = Time.now

    if @pledge.save
      ProjectPledgeSummary.pledge(@pledge.reward.project.code, @pledge.pledge_payment.total_amount)
      RewardPledgeSummary.pledge(@pledge.reward.code)

      if preapprove(@pledge)
        # redirected already to somewhere inside paypal
      else
        flash[:danger] = 'Failed to preapprove the payment. Please try again.'
        redirect_to @pledge.reward.project
      end
    else
      flash.now[:danger] = 'Failed to save. Please try again.'
      render :new
    end
  end

  # PATCH/PUT /pledges/1
  def update
    if @pledge.pledge_payment.status != Divs::PledgePaymentStatus::UNPAID
      return redirect_to :back, alert: 'This paymenr is proceeded already. You cannot modify.'
    end

    if @pledge.update(pledge_params)
      ProjectPledgeSummary.pledge(@pledge.reward.project.code, @pledge.pledge_payment.total_amount)
      RewardPledgeSummary.pledge(@pledge.reward.code)

      if preapprove(@pledge)
        # redirected already to somewhere inside paypal
      else
        flash[:danger] = 'Failed to preapprove the payment. Please try again.'
        redirect_to @pledge.reward.project
      end
    else
      flash.now[:danger] = 'Failed to save. Please try again.'
      render :edit
    end
  end

  # DELETE /pledges/1
  def destroy
    @pledge.destroy
    redirect_to pledges_url, notice: 'Pledge was successfully destroyed.'
  end

  # GET /pledges/1/complete
  def complete
    @pledge.preapprove!

    project = @pledge.reward.project
    flash[:info] = 'Successfully pledged'
    redirect_to project
  end

  # GET /pledges/1/cancel
  def cancel
    project = @pledge.reward.project

    ProjectPledgeSummary.revert(project.code, @pledge.pledge_payment.total_amount)
    RewardPledgeSummary.revert(@pledge.reward.code)

    flash.now[:info] = 'Pledge canceled'
    render :edit
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
