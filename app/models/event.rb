class Event < ActiveRecord::Base
  belongs_to :event_type
  validates_presence_of :event_type

  def self.get_normalized_for_timerange(event_types, range_in_seconds, start_at = nil)
    events = Event.all(:conditions => [
                          "event_type_id IN (?) AND created_at <= ? AND created_at > ?",
                          event_types, start_at, start_at - range_in_seconds
                        ],
                        :order => "id ASC"
                      )

    event_groups = {}
    events.each do |event|
      event_type = event.event_type
      if (event_groups[event_type].nil?) then
        event_groups[event_type] = {}
      end
      event_groups[event_type][(event.created_at - (start_at - range_in_seconds)).to_int] = event
    end

    event_groups
  end
end
