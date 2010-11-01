require 'test_helper'

class EventTest < ActiveSupport::TestCase

  setup do
    ets = EventType.all
    ets.each do |et|
      et.delete
    end

    es = Event.all
    es.each do |e|
      e.delete
    end
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
