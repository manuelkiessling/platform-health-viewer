class EventsController < ApplicationController
  before_filter :find_tag

  def index
    respond_to do |format|
      format.json { render :json => find_events_for_tag(@tag).all.to_json }
    end
  end

  def latest
    found_events = find_events_for_tag(@tag).limit(10)

    events = []
    found_events.each do |event|
      enriched_event           = event.serializable_hash
      enriched_event[:name]    = event.event_type.name
      enriched_event[:source]  = event.event_type.source
      events << enriched_event
    end

    respond_to do |format|
      format.json { render :json => events.to_json }
    end
  end

  private

    def find_tag
      @tag = Tag.find(params[:tag_id])
    end

    def find_events_for_tag(tag)
      Event.where(
        :event_type_id => EventType.find_by_sources_and_names(
          tag.resolved_event_sources,
          tag.resolved_event_names
      )).order('id DESC')
    end

end
