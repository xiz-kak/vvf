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
    @pledge = Pledge.new
    @pledge.build_pledge_payment
    @pledge.build_pledge_shipping
  end

  # GET /pledges/1/edit
  def edit
  end

  # POST /pledges
  def create
    @pledge = Pledge.new(pledge_params)

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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pledge
      @pledge = Pledge.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def pledge_params
      params.require(:pledge).permit(
        :reward_id,
        :user_id,
        :pledged_at,
        pledge_payment_attributes: [
          :id,
          :amount,
          :shipping_rate,
          :total_amount,
          :payment_method_div,
          :payment_vendor_id
        ],
        pledge_shipping_attributes: [
          :id,
          :first_name,
          :last_name,
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
