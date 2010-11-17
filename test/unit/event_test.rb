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

end
