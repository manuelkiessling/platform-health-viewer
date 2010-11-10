class TagsController < ApplicationController

  def create
    @tag = Tag.new
    @tag.name = params[:tag][:name]
    if (!params[:tag][:tags].empty?) then
      @tag.tags = params[:tag][:tags].sub(" ", "").split(",")
    else
      @tag.event_sources = params[:tag][:event_sources].sub(" ", "").split(",")
      @tag.event_names = params[:tag][:event_names].sub(" ", "").split(",")
    end
    begin
      @tag.save
      flash[:notice] = "Tag created"
    rescue
      flash[:error] = "Nope."
    end

    respond_to do |format|
      format.html { redirect_to tags_path }
      format.js
    end
  end

  def show
    @tags = Tag.all
    respond_to do |format|
      format.html
    end
  end

end
