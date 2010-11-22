namespace :queue do
  task:convert => :environment do
    qes = QueueEvent.all
    qes.each do |qe|
      puts "Handling event: " + qe.inspect.to_s
      et = EventType.first(:conditions => { :source => qe.source, :name => qe.name } )
      if (et.nil?) then
        puts "Event type does not yet exist, creating..."
        et = EventType.new
        et.source = qe.source
        et.name = qe.name
        et.save
      end
      puts "Using event type: " + et.inspect.to_s
      e = Event.new
      e.event_type_id = et.id
      e.value = qe.value
      e.created_at = qe.created_at
      e.save
      puts "Created event: " + e.inspect.to_s
      qe.delete
      puts "Deleted queue event"
    end
  end
end
