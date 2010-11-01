require 'test_helper'

class TagTest < ActiveSupport::TestCase

  setup do
    t = Tag.new
    t.name = "TESTcrons"
    t.event_sources << "TESTcron01"
    t.event_sources << "TESTcron02"
    t.save
  end

  teardown do
    tags = Tag.by_name(:name => "TESTcrons")
    tags.each do |tag|
      t = Tag.find(tag["_id"])
      t.destroy
    end
  end

  test "must return array with sources" do
    actual = Tag.sources_for_tagname("TESTcrons")
    expected = ["TESTcron01", "TESTcron02"]

    assert_equal(expected, actual)
  end

end
