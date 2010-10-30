require 'test_helper'

class QueueEventTest < ActiveSupport::TestCase

  test "must have source" do
    qe = QueueEvent.new
    qe.name = "Hello World"
    qe.value = "1"
    assert !qe.save, "Queue Event was saved without source"
  end

  test "must have name" do
    qe = QueueEvent.new
    qe.source = "The Interwebs"
    qe.value = "1"
    assert !qe.save, "Queue Event was saved without name"
  end

  test "must have value" do
    qe = QueueEvent.new
    qe.source = "The Interwebs"
    qe.name = "Hello World"
    assert !qe.save, "Queue Event was saved without value"
  end

end
