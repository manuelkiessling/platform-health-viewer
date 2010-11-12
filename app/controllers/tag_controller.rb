class TagController < ApplicationController

  def events
    tagname = params[:name]
    @events = EventType.find_by_sources_and_names(Tag.sources_for_tagname(tagname), Tag.names_for_tagname(tagname))
    respond_to do |format|
      format.html
      format.js
    end
  end

end
