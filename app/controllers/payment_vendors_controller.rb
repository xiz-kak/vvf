class PaymentVendorsController < ApplicationController
  before_action :require_admin
  before_action :set_payment_vendor, only: [:show, :edit, :update, :destroy]

  # GET /payment_vendors
  def index
    @payment_vendors = PaymentVendor.all
  end

  # GET /payment_vendors/1
  def show
  end

  # GET /payment_vendors/new
  def new
    @payment_vendor = PaymentVendor.new
  end

  # GET /payment_vendors/1/edit
  def edit
  end

  # POST /payment_vendors
  def create
    @payment_vendor = PaymentVendor.new(payment_vendor_params)

    if @payment_vendor.save
      redirect_to @payment_vendor, notice: 'Payment vendor was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /payment_vendors/1
  def update
    if @payment_vendor.update(payment_vendor_params)
      redirect_to @payment_vendor, notice: 'Payment vendor was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /payment_vendors/1
  def destroy
    @payment_vendor.destroy
    redirect_to payment_vendors_url, notice: 'Payment vendor was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment_vendor
      @payment_vendor = PaymentVendor.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def payment_vendor_params
      params.require(:payment_vendor).permit(
        :sort_order,
        :logo_image,
        payment_vendor_locales_attributes: [
          :id,
          :language_id,
          :logo_image,
          :name,
          :_destroy
        ]
      )
    end
end
