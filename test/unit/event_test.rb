require 'test_helper'

class EventTest < ActiveSupport::TestCase

  setup do
    teardown
  end

  teardown do
    EventType.delete_all
    Event.delete_all
  end

  test "must have existing event_type_id" do
    event = Event.new(:value => '4783')
    assert !event.save, "Could save with non-existant event_type_id"
  end

  test "works with existing event_type_id" do
    event_type = EventType.create!(:name => 'test', :source => 'testserver')

    event = Event.new(:event_type => event_type, :value => '4783')
    assert event.save, "Could not save with existant event_type_id"
  end

  test "get grouped and normalized event list, no average" do
    et1 = EventType.create!(:source => 'TESTcron01', :name => 'cpu_load')
    e0  = Event.create!(:event_type => et1, :value => '0.001', :created_at => '2010-11-01 15:43:06')

    e1 = Event.new
    e1.event_type = et1
    e1.value = "0.1"
    e1.created_at = "2010-11-01 15:43:10"
    e1.save

    e2            = Event.new
    e2.event_type = et1
    e2.value      = "0.2"
    e2.created_at = "2010-11-01 15:43:13"
    e2.save

    et2 = EventType.new
    et2.source = "TESTcron02"
    et2.name = "cpu_load"
    et2.save

    e3 = Event.new
    e3.event_type = et2
    e3.value = "0.3"
    e3.created_at = "2010-11-01 15:43:11"
    e3.save

    e4 = Event.new
    e4.event_type = et2
    e4.value = "0.4"
    e4.created_at = "2010-11-01 15:43:13"
    e4.save

    e5 = Event.new
    e5.event_type = et2
    e5.value = "0.7"
    e5.created_at = "2010-11-01 15:43:13"
    e5.save

    e6 = Event.new
    e6.event_type = et2
    e6.value = "0.5"
    e6.created_at = "2010-11-01 15:43:15"
    e6.save

    expected = []
    expected << {"event_type_id" => et1.id,
                 "values" =>
                   { 4 => 0.1,
                     7 => 0.2
                   }
                }
    expected << {"event_type_id" => et2.id,
                 "values" =>
                   { 5 => 0.3,
                     7 => 0.7,
                     9 => 0.5
                   }
                }

    normalized_events = Event.get_normalized_values_for_timerange([et1, et2], 60, Time.zone.parse("2010-11-01 15:44:06"))

    actual = []
    normalized_events.each_pair do |event_type_id, values|
      actual << {"event_type_id" => event_type_id,
                 "values" => values
                }
    end

    assert_equal(expected, actual)

  end

  test "get grouped and normalized event list with average" do
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
        e.created_at = t + i
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
        e.created_at = t + i
        e.save
      end
      i = i + 1
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

    normalized_events = Event.get_normalized_values_for_timerange([et1, et2], 10, Time.zone.parse("2010-11-19 11:55:10"), 5)

    actual = []
    normalized_events.each_pair do |event_type_id, values|
      actual << {"event_type_id" => event_type_id,
                 "values" => values
                }
    end

    assert_equal(expected, actual)

  end

end
