require 'test_helper'

class EventTest < ActiveSupport::TestCase

  setup do
    teardown
  end

  teardown do
    ets = EventType.all
    ets.each do |et|
      et.delete
    end

    es = Event.all
    es.each do |e|
      e.delete
    end
  end

  test "must have existing event_type_id" do
    e = Event.new
    e.value = "4783"
    assert !e.save, "Could save with non-existant event_type_id"
  end

  test "works with existing event_type_id" do
    et = EventType.new
    et.name = "test"
    et.source = "testserver"
    et.save

    e = Event.new
    e.event_type = et
    e.value = "4783"
    assert e.save, "Could not save with existant event_type_id"
  end

  test "get full events for certain event types" do
    et1 = EventType.new
    et1.source = "TESTcron01"
    et1.name = "cpu_load"
    et1.save

    e1 = Event.new
    e1.event_type = et1
    e1.value = "0.11"
    e1.created_at = "2010-11-01 15:43:26.642887"
    e1.save

    e2 = Event.new
    e2.event_type = et1
    e2.value = "0.12"
    e2.created_at = "2010-11-01 15:43:26.642887"
    e2.save

    et2 = EventType.new
    et2.source = "TESTcron02"
    et2.name = "cpu_load"
    et2.save

    e3 = Event.new
    e3.event_type = et2
    e3.value = "0.21"
    e3.created_at = "2010-11-01 15:43:26.642887"
    e3.save

    events = Event.find_all_by_event_type_id([et1.id, et2.id])

    assert_equal([e1, e2, e3], events)
  end

  test "get grouped and averaged event list" do
    t = Time.zone.parse("2010-11-19 11:55:00")

    et1 = EventType.new
    et1.source = "TESTcron01"
    et1.name = "cpu_load"
    et1.save

    i = 1
    12.times do
      Event.new do |e|
        e.value = i
        e.event_type = et1
        e.created_at = t + (i * 60)
        e.save
      end
      i = i + 1
    end

    et2 = EventType.new
    et2.source = "TESTcron02"
    et2.name = "cpu_load"
    et2.save

    i = 1
    12.times do
      Event.new do |e|
        e.value = i * 2
        e.event_type = et2
        e.created_at = t + (i * 60)
        e.save
      end
      i = i + 1
    end

    Event.new do |e|
      e.value = 9999
      e.event_type = et2
      e.created_at = Time.zone.parse("2010-11-19 14:45:00")
      e.save
    end


    expected = []
    expected << {"event_type_id" => et1.id,
                 "values" =>
                   { 0 => 3.0,
                     1 => 8.0
                   }
                }
     expected << {"event_type_id" => et2.id,
                 "values" =>
                   { 0 => 6.0,
                     1 => 16.0,
                   }
                }

    normalized_events = Event.get_grouped_and_averaged_values_for_timerange(:event_types => [et1, et2],
                                                                            :range_in_seconds => 1200,
                                                                            :end_at => Time.zone.parse("2010-11-19 12:15:00"),
                                                                            :chunk_size => 5)

    actual = []
    normalized_events.each_pair do |event_type_id, values|
      actual << {"event_type_id" => event_type_id,
                 "values" => values
                }
    end

    assert_equal(expected, normalized_events)

  end

end
