class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  # GET /projects
  def index
    @projects = Project.all
  end

  # GET /projects/1
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
    # langs = Language.all.order(:sort_order)
    # langs.each do |l|
    #   @project.project_locales.build(language_id: l.id)
    # end
    @project.project_headers.build
    @project.project_contents.build
  end

  # GET /projects/1/edit
  def edit
  end

  # GET /projects/1/edit_rewards
  def edit_rewards
    @project = Project.find(params[:id])
  end

  # POST /projects
  def create
    @project = Project.new(project_params)

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
      # if params[:next_view] == 'edit'
      #   render :edit
      # else
      #   redirect_to @project, notice: 'Project was successfully updated.'
      # end
    else
      render :edit
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
      # params[:project][:project_locales_attributes].each { |index, hash| \
      #   hash[:_destroy] = hash[:language_id].blank? }
      params.require(:project).permit(
        :id,
        :category_id,
        :goal_amount,
        :duration_days,
        :is_last_step,
        project_locales_attributes: [
          :id,
          :language_id,
          :is_main,
          :_destroy
        ],
        project_headers_attributes: [
          :id,
          :language_id,
          :image_path,
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
          :_destroy,
          reward_contents_attributes: [
            :id,
            :language_id,
            :title,
            :image_path,
            :description,
            :_destroy
          ]
        ]
      )
    end
end
