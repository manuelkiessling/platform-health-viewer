class EventsController < ApplicationController

  def index
    tag_name = Tag.find(params[:tag_id]).name
    @events = Event.all(:conditions => {
                          :event_type_id => EventType.find_by_sources_and_names(
                                              Tag.sources_for_tagname(tag_name),
                                              Tag.names_for_tagname(tag_name)
                                            )
                        },
                        :order => "id DESC"
                      )
    respond_to do |format|
      format.html
      format.js
      format.json { render :json => @events.to_json }
    end
  end

  def show
    
  end

  def latest
    @tag_id = params[:tag_id]
    tag_name = Tag.find(@tag_id).name
    @events = Event.all(:conditions => {
                          :event_type_id => EventType.find_by_sources_and_names(
                                              Tag.sources_for_tagname(tag_name),
                                              Tag.names_for_tagname(tag_name)
                                            )
                        },
                        :order => "id DESC",
                        :limit => 10
                      )
    respond_to do |format|
      format.html
      format.js
      format.json { render :json => @events.to_json }
    end
  end

end
