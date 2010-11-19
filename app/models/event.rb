class Event < ActiveRecord::Base
  belongs_to :event_type
  validates_presence_of :event_type

  def self.get_normalized_values_for_timerange(event_types, range_in_seconds, end_at = nil, average = nil)
    if (end_at.nil?) then
      end_at = Time.zone.now
    end

    begin_at = end_at - range_in_seconds

    if (!average.nil?) then

      number_of_blocks = range_in_seconds / average
      event_groups = {}
      i = 0
      number_of_blocks.times do
        block_begin_at = begin_at + (average * i)
        block_end_at = block_begin_at + average
        values = Event.average(:value, :conditions => [
                          "event_type_id IN (?) AND created_at <= ? AND created_at > ?",
                          event_types, block_end_at, block_begin_at
                        ],
                        :group => "event_type_id",
                        :order => "created_at ASC"
                      )
        values.each_pair do |event_type_id, value|
          if (event_groups[event_type_id].nil?) then
            event_groups[event_type_id] = {}
          end
          event_groups[event_type_id][i] = value
        end
        i = i + 1
      end

    else

      events = Event.all(:conditions => [
                            "event_type_id IN (?) AND created_at <= ? AND created_at > ?",
                            event_types, end_at, begin_at
                          ],
                          :order => "created_at ASC"
                        )

      event_groups = {}
      events.each do |event|
        event_type_id = event.event_type_id
        if (event_groups[event_type_id].nil?) then
          event_groups[event_type_id] = {}
        end
        event_groups[event_type_id][(event.created_at - (begin_at)).to_int] = event.value
      end

    end

    event_groups
  end
end
