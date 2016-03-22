class ProjectsController < ApplicationController
  before_action :require_admin, only: [:destroy]
  before_action :set_project, only: [:show, :edit, :edit_rewards, :update, :destroy]
  before_action :require_login, except: [:index, :show]
  before_action :require_owner_allowed, only: [:edit, :edit_rewards, :update]

  # GET /projects
  def index
    @projects = Project.all.order(:id)
  end

  # GET /projects/1
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # GET /projects/1/edit_rewards
  def edit_rewards
  end

  # POST /projects
  def create
    @project = Project.new(project_params)
    @project.user = current_user
    @project.status_div = Division.div(:project_status, :draft)

    if @project.save
      redirect_to @project, notice: 'Project was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /projects/1
  def update
    if @project.update(project_params)
      redirect_to @project, notice: 'Project was successfully updated.'
    else
      if params[:update_rewards].present?
        render :edit_rewards
      else
        render :edit
      end
    end
  end

  # DELETE /projects/1
  def destroy
    @project.destroy
    redirect_to projects_url, notice: 'Project was successfully destroyed.'
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
      # hash[:_destroy] = hash[:use_this_language] != "1"
      hash[:is_main] = hash[:language_id] == params[:project][:main_language_id]
    end
    params.require(:project).permit(
      :id,
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
        :_destroy,
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

  # Filter: owner of the project and allowed to edit
  def require_owner_allowed
    render_404 unless @project.user == current_user
    # [wip] must be in the editable status
  end
end
