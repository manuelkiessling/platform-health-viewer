class Event < ActiveRecord::Base
  belongs_to :event_type
  validates_presence_of :event_type

  def self.get_normalized_values_for_timerange(event_types, range_in_seconds, end_at = nil, average = nil)

    if (!average.nil?) then

      rows = self.get_values_for_timerange(event_types, range_in_seconds, end_at, average)

      event_groups = {}
      i = 0
      rows.each do |row|
        puts i
        if (event_groups[row.event_type_id].nil?) then
          event_groups[row.event_type_id] = {}
        end
        event_groups[row.event_type_id][i] = row.average.to_f
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

  def self.get_values_for_timerange(event_types, range_in_seconds, end_at = nil, average = nil)
    if (end_at.nil?) then
      end_at = Time.zone.now
    end

    begin_at = end_at - range_in_seconds

    sql = "SELECT event_type_id, AVG( value ) AS average,

      CONCAT(
        EXTRACT(YEAR FROM created_at), '-',
        EXTRACT(MONTH FROM created_at), '-',
        EXTRACT(DAY FROM created_at), ' ',
        EXTRACT(HOUR FROM created_at), ':',
        FLOOR( EXTRACT( MINUTE FROM created_at ) / ? ) * ?, ':',
        '00'
      ) AS block,
      created_at
    FROM events
    WHERE
          event_type_id IN (?)
      AND created_at > ?
      AND created_at <= ?
    GROUP BY block,event_type_id ORDER BY block ASC"

    Event.find_by_sql([sql, average, average, event_types, begin_at.to_formatted_s(:db), end_at.to_formatted_s(:db)])
  end

end
