require 'test_helper'

class EventTest < ActiveSupport::TestCase

  setup do
    teardown

    et = EventType.new
    et.source = "TESTcron01"
    et.name = "cpu_load"
    et.save

    e = Event.new
    e.event_type = et
    e.value = "0.11"
    e.created_at = "2010-11-01 15:43:26.642887"
    e.save

    e = Event.new
    e.event_type = et
    e.value = "0.12"
    e.created_at = "2010-11-01 15:43:26.642887"
    e.save

    et = EventType.new
    et.source = "TESTcron02"
    et.name = "cpu_load"
    et.save

    e = Event.new
    e.event_type = et
    e.value = "0.21"
    e.created_at = "2010-11-01 15:43:26.642887"
    e.save

    e = Event.new
    e.event_type = et
    e.value = "0.22"
    e.created_at = "2010-11-01 15:43:26.642887"
    e.save

    et = EventType.new
    et.source = "TESTcron02"
    et.name = "free_mem"
    et.save

    e = Event.new
    e.event_type = et
    e.value = "21%"
    e.created_at = "2010-11-01 15:43:26.642887"
    e.save

    e = Event.new
    e.event_type = et
    e.value = "22%"
    e.created_at = "2010-11-01 15:43:26.642887"
    e.save
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

end
