namespace :queue do
  task:convert => :environment do
    QueueEvent.all.each do |queue_event|
      puts "Handling event: " + queue_event.inspect.to_s
      event_type = EventType.find_or_create_by_source_and_name(:source => queue_event.source, :name => queue_event.name)
      puts "Using event type: " + event_type.inspect.to_s

      event = Event.create(:event_type => event_type, :value => queue_event.value, :created_at => queue_event.created_at)
      puts "Created event: " + event.inspect.to_s
      queue_event.delete
      puts "Deleted queue event"
    end
  end
end
