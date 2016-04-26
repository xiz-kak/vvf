class DiscoverController < ApplicationController
  def top
  end

  def search
    @term = params[:term].blank? ? nil : params[:term]
    if @term
      @projects = Project.search_by_term(@term)
    else
      @projects = Project.active.limit(20)
    end
  end

  def category
    @category = Category.find(params[:id])
    @projects = Project.search_by_category(@category)

    render :search
  end
end
