class DivisionsController < ApplicationController
  before_action :require_admin
  before_action :set_division, only: [:show, :edit, :update, :destroy]

  # GET /divisions
  def index
    @divisions = Division.all
  end

  # GET /divisions/1
  def show
  end

  # GET /divisions/new
  def new
    @division = Division.new
  end

  # GET /divisions/1/edit
  def edit
  end

  # POST /divisions
  def create
    @division = Division.new(division_params)

    if @division.save
      redirect_to @division, notice: 'Division was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /divisions/1
  def update
    if @division.update(division_params)
      redirect_to @division, notice: 'Division was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /divisions/1
  def destroy
    @division.destroy
    redirect_to divisions_url, notice: 'Division was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_division
      @division = Division.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def division_params
      params.require(:division).permit(
        :code,
        :val,
        :sort_order,
        :description,
        division_locales_attributes: [
          :id,
          :language_id,
          :name,
          :_destroy
        ]
      )
    end
end
