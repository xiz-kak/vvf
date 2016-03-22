class NationsController < ApplicationController
  before_action :require_admin
  before_action :set_nation, only: [:show, :edit, :update, :destroy]

  # GET /nations
  def index
    @nations = Nation.all
  end

  # GET /nations/1
  def show
  end

  # GET /nations/new
  def new
    @nation = Nation.new
  end

  # GET /nations/1/edit
  def edit
  end

  # POST /nations
  def create
    @nation = Nation.new(nation_params)

    if @nation.save
      redirect_to @nation, notice: 'Nation was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /nations/1
  def update
    if @nation.update(nation_params)
      redirect_to @nation, notice: 'Nation was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /nations/1
  def destroy
    @nation.destroy
    redirect_to nations_url, notice: 'Nation was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_nation
      @nation = Nation.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def nation_params
      params.require(:nation).permit(:name, :alpha_2_code, :alpha_3_code, :numeric_code, :is_to_ship)
    end
end
