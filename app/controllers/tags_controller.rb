class TagsController < ApplicationController

  def self.get_splitted_string(string)
    r = []
    string.split(",").each do |s|
      if (s.sub(" ", "") != "") then
        r << s.sub(" ", "")
      end
    end
    r
  end

  def create
    @tag = Tag.new
    @tag.name = params[:tag][:name]
    if (!params[:tag][:tags].empty?) then
      @tag.tags = TagsController.get_splitted_string(params[:tag][:tags])
    else
      @tag.event_sources = TagsController.get_splitted_string(params[:tag][:event_sources])
      @tag.event_names = TagsController.get_splitted_string(params[:tag][:event_names])
    end
    begin
      @tag.save
      flash[:notice] = "Tag created"
    rescue Exception => e
      flash[:error] = "Error: " + e.message
    end

    respond_to do |format|
      format.html { redirect_to tags_path }
      format.js
    end
  end

  def index
    @tags = Tag.all
    respond_to do |format|
      format.html
      format.xml { render :xml => @tags.to_xml }
      format.json { render :json => @tags.to_json }
    end
  end

end
