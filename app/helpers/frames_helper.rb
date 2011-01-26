module FramesHelper

  def prepare_events_for_raphael(event_groups, num_cols)
    x = []
    data = []
    x << num_cols.times.collect
    zerodata = []
    num_cols.times { zerodata << 0 }
    data << zerodata
    event_groups.each_pair do |event_type_id, values|
      gx = []
      gdata = []
      values.keys.sort.each do |key|
        gx << key
        gdata << values[key]
      end
      x << gx
      data << gdata
    end
    return {"x" => x.inspect.to_s, "data" => data.inspect.to_s}
  end
  
  def get_event_type_names_for_google_graph(averaged_events)
    event_type_names = ""
    averaged_events.each_pair do |i, averaged_event|
      event_type = EventType.find(averaged_event["event_type_id"])
      event_type_names = event_type_names + event_type.source + ": " + event_type.name + "|"
    end
    return event_type_names[0..-2]
  end

  def get_event_type_colors_for_google_graph(averaged_events)
    event_type_colors = ""
    averaged_events.each_pair do |i, averaged_event|
      event_type = EventType.find(averaged_event["event_type_id"])
      event_type_colors = event_type_colors + ("%06x" % (rand * 0xffffff)).to_s + ","
    end
    return event_type_colors[0..-2]
  end
  
  def get_event_type_average_values_for_google_graph(averaged_events)
    event_type_average_values = ""

    averaged_events.each_pair do |i, averaged_event|
      averaged_event["values"].each_pair do |j, value|
        event_type_average_values = event_type_average_values.to_s + value["value"].to_s + ","
      end
      event_type_average_values = event_type_average_values[0..-2]
      event_type_average_values = event_type_average_values + "|"
    end
    return event_type_average_values[0..-2]
  end

end
