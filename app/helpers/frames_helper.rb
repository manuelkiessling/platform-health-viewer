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

end
