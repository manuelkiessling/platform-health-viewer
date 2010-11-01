require 'test_helper'

class EventTypeTest < ActiveSupport::TestCase

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

end
