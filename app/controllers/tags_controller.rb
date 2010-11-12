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

  def show
    @tags = Tag.all
    respond_to do |format|
      format.html
    end
  end

  def events
    tagname = params[:tagname]
    @tagid = params[:tagid]
    @events = EventType.find_by_sources_and_names(Tag.sources_for_tagname(tagname), Tag.names_for_tagname(tagname))
    respond_to do |format|
      format.html { redirect_to tags_path }
      format.js
    end
  end

end
