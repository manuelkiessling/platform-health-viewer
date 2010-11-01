class Result

  def self.find(sources, names, event_type_class)
    results = []
    if (!sources.empty?)
      sources.each do |source|
        if (!names.empty?)
          names.each do |name|
            event_type = event_type_class.find(:first, :conditions => { :source => source, :name => name })
            if (!event_type.nil?) then
              event_type.events.each do |event|
                results = results | [ "source" => event_type.source, "name" => event_type.name, "value" => event.value ]
              end
            end
          end
        else
          event_types = event_type_class.find(:all, :conditions => { :source => source })
          event_types.each do |event_type|
            if (!event_type.nil?) then
              event_type.events.each do |event|
                results = results | [ "source" => event_type.source, "name" => event_type.name, "value" => event.value ]
              end
            end
          end
        end
      end
    else
      names.each do |name|
        event_types = event_type_class.find(:all, :conditions => { :name => name })
        event_types.each do |event_type|
          if (!event_type.nil?) then
            event_type.events.each do |event|
              results = results | [ "source" => event_type.source, "name" => event_type.name, "value" => event.value ]
            end
          end
        end
      end
    end
    results
  end

end
