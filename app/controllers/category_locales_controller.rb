class CategoryLocalesController < ApplicationController
  before_action :set_category_locale, only: [:show, :edit, :update, :destroy]

  # GET /category_locales
  def index
    @category_locales = CategoryLocale.all
  end

  # GET /category_locales/1
  def show
  end

  # GET /category_locales/new
  def new
    @category_locale = CategoryLocale.new
  end

  # GET /category_locales/1/edit
  def edit
  end

  # POST /category_locales
  def create
    @category_locale = CategoryLocale.new(category_locale_params)

    if @category_locale.save
      redirect_to @category_locale, notice: 'Category locale was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /category_locales/1
  def update
    if @category_locale.update(category_locale_params)
      redirect_to @category_locale, notice: 'Category locale was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /category_locales/1
  def destroy
    @category_locale.destroy
    redirect_to category_locales_url, notice: 'Category locale was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category_locale
      @category_locale = CategoryLocale.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def category_locale_params
      params.require(:category_locale).permit(:category_id, :name, :language_id)
    end
end
