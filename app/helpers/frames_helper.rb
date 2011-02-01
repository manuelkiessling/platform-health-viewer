module FramesHelper
  
  def get_names_for_google_graph(averaged_events)
    event_type_names = ""
    averaged_events.each do |averaged_event|
      event_type = EventType.find(averaged_event["event_type_id"])
      event_type_names = event_type_names + event_type.source + ": " + event_type.name + "|"
    end
    return event_type_names[0..-2]
  end

  def get_colors_for_google_graph(averaged_events)
    event_type_colors = ""
    averaged_events.each do |averaged_event|
      event_type_colors = event_type_colors + ("%06x" % (rand * 0xffffff)).to_s + ","
    end
    return event_type_colors[0..-2]
  end
  
  def get_values_for_google_graph(averaged_events)
    event_type_average_values = ""

    averaged_events.each do |averaged_event|
      averaged_event["values"].each do |value|
        if value["value"].nil? then value["value"] = '_' end
        event_type_average_values = event_type_average_values.to_s + value["value"].to_s + ","
      end
      event_type_average_values = event_type_average_values[0..-2]
      event_type_average_values = event_type_average_values + "|"
    end
    return event_type_average_values[0..-2]
  end

  def get_values_for_graphlib(averaged_events)
    all = []
    event_type_average_values = ""

    averaged_events.each do |averaged_event|
      event_type_values = []
      averaged_event["values"].each do |value|
        if value["value"].nil? then value["value"] = 0.0 end
        event_type_values << value["value"]
      end
      all << event_type_values
    end
    return all
  end

end
