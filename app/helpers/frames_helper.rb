module FramesHelper
  
  def labels_for_gchart(averaged_events)
    event_type_names = ""
    averaged_events.each do |averaged_event|
      event_type = EventType.find(averaged_event["event_type_id"])
      event_type_names = event_type_names + event_type.source + ": " + event_type.name + "|"
    end
    return event_type_names[0..-2]
  end

  def line_colors_for_gchart(averaged_events)
    event_type_colors = ""
    averaged_events.each do |averaged_event|
      event_type_colors = event_type_colors + ("%06x" % (rand * 0xffffff)).to_s + ","
    end
    return event_type_colors[0..-2]
  end
  
  def data_for_gchart(averaged_events)
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
  
  def gchart_url_for_frame(options = {})
    event_types = EventType.find_by_sources_and_names(
    Tag.sources_for_tagname(options[:frame].tag),
    Tag.names_for_tagname(options[:frame].tag)
    )

    averages_calculator = AveragesCalculator.new()
    averaged_events = averages_calculator.calculate_for(:event_types  => event_types,
                                                        :between      => Time.zone.now - options[:timerange],
                                                        :and          => Time.zone.now,
                                                        :in_chunks_of => options[:chunk_size],
                                                        :minutes      => true)

    ::Gchart.line(:size => options[:frame].width.to_s + "x" + options[:frame].height.to_s,
                  :line_colors => line_colors_for_gchart(averaged_events),
                  :labels => labels_for_gchart(averaged_events),
                  :data => data_for_gchart(averaged_events),
                  :axis_with_labels => 'r')
  end

end
