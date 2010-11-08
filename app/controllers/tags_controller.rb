class TagsController < ApplicationController

  def create
    @tag = Tag.new
    @tag.name = params[:tag][:name]
    @tag.save
    flash[:notice] = "Tag created"
    respond_to do |format|
      format.html { redirect_to tags_path }
      format.js
    end
  end

  def show
    @tags = Tag.all
    respond_to do |format|
      format.html
      format.rss
    end
  end

end
