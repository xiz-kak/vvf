class PledgesController < ApplicationController
  before_action :require_admin, only: [:edit, :update, :destroy]
  before_action :set_pledge, only: [:show, :edit, :update, :destroy]
  before_action :require_login, except: [:index, :show]

  # GET /pledges
  def index
    @pledges = Pledge.all
  end

  # GET /pledges/1
  def show
  end

  # GET /pledges/new
  def new
    @pledge = Pledge.new(reward_id: params[:reward_id])
    @pledge.build_pledge_payment
    @pledge.build_pledge_shipping

    @pledge.pledge_payment.amount = @pledge.reward.price
    @pledge.pledge_payment.shipping_rate = 0
    @pledge.pledge_payment.total_amount = @pledge.reward.price
  end

  # GET /pledges/1/edit
  def edit
  end

  # POST /pledges
  def create
    @pledge = Pledge.new(pledge_params)
    @pledge.user = current_user
    @pledge.pledged_at = Time.zone.now

    if @pledge.save
      redirect_to @pledge, notice: 'Pledge was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /pledges/1
  def update
    if @pledge.update(pledge_params)
      redirect_to @pledge, notice: 'Pledge was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /pledges/1
  def destroy
    @pledge.destroy
    redirect_to pledges_url, notice: 'Pledge was successfully destroyed.'
  end

  # POST rewards/1/shipping_rate
  def shipping_rate
    sr = Reward.find(params[:reward_id]).shipping_rate(params[:nation_id])
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
        :reward_id,
        pledge_payment_attributes: [
          :id,
          :amount,
          :payment_method_div,
          :payment_vendor_id
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
end
