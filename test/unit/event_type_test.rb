require 'test_helper'

class EventTypeTest < ActiveSupport::TestCase

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
      et.destroy
    end

    es = Event.all
    es.each do |e|
      e.destroy
    end
  end

  test "must have source" do
    et = EventType.new
    et.name = "Hello World"
    assert !et.save, "Event Type was saved without source"
  end

  test "must have name" do
    et = EventType.new
    et.source = "The Interwebs"
    assert !et.save, "Event Type was saved without name"
  end

  test "no duplicate event types" do
    et = EventType.new
    et.source = "The Interwebs"
    et.name = "Search Page"
    et.save
    et = EventType.new
    et.source = "The Interwebs"
    et.name = "Search Page"
    assert_raise(ActiveRecord::RecordNotUnique) do
      et.save
    end
  end

  test "test find with 2 sources and 1 name" do
    actual = EventType.find_by_sources_and_names(["TESTcron01", "TESTcron02"], ["free_mem"])

    expected = [{"created_at" => "2010-11-01 15:43:26 UTC", "source" => "TESTcron02", "name" => "free_mem", "value" => "21%"},
                {"created_at" => "2010-11-01 15:43:26 UTC", "source" => "TESTcron02", "name" => "free_mem", "value" => "22%"}
               ]

    assert_equal(expected, actual)
  end

  test "find with 1 source and 1 name nonexistant" do
    actual = EventType.find_by_sources_and_names(["TESTcron01"], ["free_mem"])

    expected = []

    assert_equal(expected, actual)
  end

  test "find with 2 sources and no name" do
    actual = EventType.find_by_sources_and_names(["TESTcron01", "TESTcron02"], [])

    expected = [{"created_at" => "2010-11-01 15:43:26 UTC", "source" => "TESTcron01", "name" => "cpu_load", "value" => "0.11"},
                {"created_at" => "2010-11-01 15:43:26 UTC", "source" => "TESTcron01", "name" => "cpu_load", "value" => "0.12"},
                {"created_at" => "2010-11-01 15:43:26 UTC", "source" => "TESTcron02", "name" => "cpu_load", "value" => "0.21"},
                {"created_at" => "2010-11-01 15:43:26 UTC", "source" => "TESTcron02", "name" => "cpu_load", "value" => "0.22"},
                {"created_at" => "2010-11-01 15:43:26 UTC", "source" => "TESTcron02", "name" => "free_mem", "value" => "21%"},
                {"created_at" => "2010-11-01 15:43:26 UTC", "source" => "TESTcron02", "name" => "free_mem", "value" => "22%"}
               ]

    assert_equal(expected, actual)
  end

  test "find with no sources and 1 name" do
    actual = EventType.find_by_sources_and_names([], ["cpu_load"])

    expected = [{"created_at" => "2010-11-01 15:43:26 UTC", "source" => "TESTcron01", "name" => "cpu_load", "value" => "0.11"},
                {"created_at" => "2010-11-01 15:43:26 UTC", "source" => "TESTcron01", "name" => "cpu_load", "value" => "0.12"},
                {"created_at" => "2010-11-01 15:43:26 UTC", "source" => "TESTcron02", "name" => "cpu_load", "value" => "0.21"},
                {"created_at" => "2010-11-01 15:43:26 UTC", "source" => "TESTcron02", "name" => "cpu_load", "value" => "0.22"}
               ]

    assert_equal(expected, actual)
  end

  test "find with no sources and 2 names" do
    actual = EventType.find_by_sources_and_names([], ["cpu_load", "free_mem"])

    expected = [{"created_at" => "2010-11-01 15:43:26 UTC", "source" => "TESTcron01", "name" => "cpu_load", "value" => "0.11"},
                {"created_at" => "2010-11-01 15:43:26 UTC", "source" => "TESTcron01", "name" => "cpu_load", "value" => "0.12"},
                {"created_at" => "2010-11-01 15:43:26 UTC", "source" => "TESTcron02", "name" => "cpu_load", "value" => "0.21"},
                {"created_at" => "2010-11-01 15:43:26 UTC", "source" => "TESTcron02", "name" => "cpu_load", "value" => "0.22"},
                {"created_at" => "2010-11-01 15:43:26 UTC", "source" => "TESTcron02", "name" => "free_mem", "value" => "21%"},
                {"created_at" => "2010-11-01 15:43:26 UTC", "source" => "TESTcron02", "name" => "free_mem", "value" => "22%"}
               ]

    assert_equal(expected, actual)
  end

  test "find with 2 sources and 2 names" do
    actual = EventType.find_by_sources_and_names(["TESTcron01", "TESTcron02"], ["cpu_load", "free_mem"])

    expected = [{"created_at" => "2010-11-01 15:43:26 UTC", "source" => "TESTcron01", "name" => "cpu_load", "value" => "0.11"},
                {"created_at" => "2010-11-01 15:43:26 UTC", "source" => "TESTcron01", "name" => "cpu_load", "value" => "0.12"},
                {"created_at" => "2010-11-01 15:43:26 UTC", "source" => "TESTcron02", "name" => "cpu_load", "value" => "0.21"},
                {"created_at" => "2010-11-01 15:43:26 UTC", "source" => "TESTcron02", "name" => "cpu_load", "value" => "0.22"},
                {"created_at" => "2010-11-01 15:43:26 UTC", "source" => "TESTcron02", "name" => "free_mem", "value" => "21%"},
                {"created_at" => "2010-11-01 15:43:26 UTC", "source" => "TESTcron02", "name" => "free_mem", "value" => "22%"}
               ]

    assert_equal(expected, actual)
  end

end
