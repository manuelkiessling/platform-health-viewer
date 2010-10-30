class Result
  def get_by_tagname(tagname)
    results = []
    tag = get_tag_by_name(tagname)
    if (!tag.event_sources.empty?)
      tag.event_sources.each do |event_source|
        if (!tag.event_names.empty?)
          tag.event_names.each do |event_name|
            results = results | Event.by_source_and_name(:key => [event_source, event_name])
          end
        else
          results = results | Event.by_source(:key => event_source)
        end
      end
    else
      tag.event_names.each do |event_name|
        results = results | Event.by_name(:key => event_name)
      end
    end
    results
    #results.sort_by { |result| result[:timestamp] }
  end

  def get_tag_by_name(name)
    get_tag_from_array(Tag.by_name(:key => name))
  end

  def get_tag_from_array (tag_array)
    Tag.find(tag_array[0]["_id"])
  end
end
