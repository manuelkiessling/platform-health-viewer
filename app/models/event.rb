class Event < ActiveRecord::Base
  belongs_to :event_type
  validates_presence_of :event_type

  def self.get_normalized_for_timerange(event_types, range_in_seconds, start_at = nil)
    events = Event.all(:conditions => [
                          "event_type_id IN (?) AND created_at <= ? AND created_at > ?",
                          event_types, start_at, start_at - range_in_seconds
                        ],
                        :order => "created_at ASC"
                      )

    event_groups = {}
    events.each do |event|
      event_type_id = event.event_type_id
      if (event_groups[event_type_id].nil?) then
        event_groups[event_type_id] = {}
      end
      event_groups[event_type_id][(event.created_at - (start_at - range_in_seconds)).to_int] = event
    end

    event_groups
  end
end
