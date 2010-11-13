class EventType < ActiveRecord::Base
  has_many :events
  validates_presence_of :source, :name

  def self.find_by_sources_and_names(sources, names)
    results = []
    if (!sources.empty?)
      sources.each do |source|
        if (!names.empty?)
          names.each do |name|
            event_type = self.find(:first, :conditions => { :source => source, :name => name })
            if (!event_type.nil?) then
              event_type.events.each do |event|
                results = results | [ "created_at" => event.created_at.to_s, "source" => event_type.source, "name" => event_type.name, "value" => event.value ]
              end
            end
          end
        else
          event_types = self.find(:all, :conditions => { :source => source })
          event_types.each do |event_type|
            if (!event_type.nil?) then
              event_type.events.each do |event|
                results = results | [ "created_at" => event.created_at.to_s, "source" => event_type.source, "name" => event_type.name, "value" => event.value ]
              end
            end
          end
        end
      end
    else
      names.each do |name|
        event_types = self.find(:all, :conditions => { :name => name })
        event_types.each do |event_type|
          if (!event_type.nil?) then
            event_type.events.each do |event|
              results = results | [ "created_at" => event.created_at.to_s, "source" => event_type.source, "name" => event_type.name, "value" => event.value ]
            end
          end
        end
      end
    end
    results
  end

end
