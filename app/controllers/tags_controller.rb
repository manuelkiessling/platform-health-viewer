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
    @tag.tags = TagsController.get_splitted_string(params[:tag][:tags])
    @tag.event_sources = TagsController.get_splitted_string(params[:tag][:event_sources])
    @tag.event_names = TagsController.get_splitted_string(params[:tag][:event_names])
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
    @event_types = EventType.all(:order => 'source ASC')
    respond_to do |format|
      format.html
      format.xml { render :xml => @tags.to_xml }
      format.json { render :json => @tags.to_json }
    end
  end

  def destroy
    tag = Tag.find(params[:id])
    @tag_id = tag.id
    tag.destroy
    respond_to do |format|
      format.js
    end
  end

end
