require "/Users/manuel/Dropbox/Projects/rbTimeChunker/lib/time_range.rb"
require "/Users/manuel/Dropbox/Projects/rbTimeChunker/lib/chunk_size.rb"
require "/Users/manuel/Dropbox/Projects/rbTimeChunker/lib/time_chunker.rb"

class AveragesCalculator

  def calculate_for(options = {})
    normalized_options = {}
    normalized_options[:event_types] = options[:event_types]
    normalized_options[:begin_at] = options[:between]
    normalized_options[:end_at] = options[:and]
    normalized_options[:chunk_size] = options[:in_chunks_of]
    get_grouped_and_averaged_values_for_timerange(normalized_options)
  end


  private

  def get_grouped_and_averaged_values_for_timerange(options = {})
     averages = {}
     rows = get_values_for_timerange(options)
     rows.each do |row|
       if (averages[row.event_type_id].nil?)
         averages[row.event_type_id] = {}
       end
       averages[row.event_type_id][row.chunk] = row.average.to_f
     end

     chunks = get_time_chunks(options[:begin_at], options[:end_at], options[:chunk_size])
     event_groups = {}
     i = 0
     options[:event_types].each do |event_type|
       event_groups[i] = {"event_type_id" => event_type.id, "values" => {}}
       j = 0
       chunks.each do |chunk|
         if (averages[event_type.id][chunk].nil?)
           event_groups[i]["values"][j] = {"chunk" => chunk, "value" => 0.0}
         else
           event_groups[i]["values"][j] = {"chunk" => chunk, "value" => averages[event_type.id][chunk]}
         end

         j = j + 1
       end
       i = i + 1
     end

     event_groups
   end

   def get_time_chunks(begin_at, end_at, chunk_size)
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

   def get_values_for_timerange(options = {})
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
