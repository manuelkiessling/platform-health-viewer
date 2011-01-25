require "/Users/manuel/Dropbox/Projects/rbTimeChunker/lib/time_range.rb"
require "/Users/manuel/Dropbox/Projects/rbTimeChunker/lib/chunk_size.rb"
require "/Users/manuel/Dropbox/Projects/rbTimeChunker/lib/time_chunker.rb"

class Event < ActiveRecord::Base
  belongs_to :event_type
  validates_presence_of :event_type

  def self.get_grouped_and_averaged_values_for_timerange(options = {})
    event_types = options[:event_types]
    options[:end_at] = options[:end_at] || end_at = Time.zone.now
    options[:begin_at] = options[:end_at] - options[:range_in_seconds]
    options[:chunk_size] = options[:chunk_size] || 1
    
    chunks = self.get_time_chunks(options[:begin_at], options[:end_at], options[:chunk_size])
    event_groups = {}

    event_types.each do |event_type|
      event_groups[event_type.id] = {}
      chunks.each do |chunk|
        event_groups[event_type.id][chunk] = 0.0
      end
    end
    
    rows = self.get_values_for_timerange(options)

    rows.each do |row|
      event_groups[row.event_type_id][row.chunk] = row.average.to_f
    end

    event_groups
  end


  private
  
  def self.get_time_chunks(begin_at, end_at, chunk_size)
    time_range = TimeRange.new(begin_at, end_at)
    chunk_size = ChunkSize.new(chunk_size, 'minutes')

    time_chunker = TimeChunker.new
    chunks = time_chunker.get_chunks(time_range, chunk_size)
    
    chunks_as_string = []
    chunks.each do |chunk|
      chunks_as_string << chunk.to_formatted_s(:db)
    end
    return chunks_as_string
  end

  def self.get_values_for_timerange(options = {})
    event_types = options[:event_types]
    range_in_seconds = options[:range_in_seconds]
    begin_at = options[:begin_at]
    end_at = options[:end_at]
    chunk_size = options[:chunk_size]

    sql = "SELECT event_type_id, AVG( value ) AS average,

      CONCAT(
        EXTRACT(YEAR FROM created_at), '-',
        LPAD(EXTRACT(MONTH FROM created_at), 2, '0'), '-',
        LPAD(EXTRACT(DAY FROM created_at), 2, '0'), ' ',
        LPAD(EXTRACT(HOUR FROM created_at), 2, '0'), ':',
        LPAD( FLOOR( EXTRACT(MINUTE FROM created_at) / ? ) * ?, 2, '0'), ':',
        '00'
      ) AS chunk,
      created_at
    FROM events
    WHERE
          event_type_id IN (?)
      AND created_at > ?
      AND created_at <= ?
    GROUP BY chunk, event_type_id ORDER BY chunk ASC"

    Event.find_by_sql([sql, chunk_size, chunk_size, event_types, begin_at.to_formatted_s(:db), end_at.to_formatted_s(:db)])
  end

end
