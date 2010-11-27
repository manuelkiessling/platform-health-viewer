require 'test_helper'

class TagTest < ActiveSupport::TestCase

  setup do
    teardown
    
    t = Tag.new
    t.name = "TESTcrons"
    t.event_sources << "TESTcron01"
    t.event_sources << "TESTcron02"
    t.event_names << "cpu_load"
    t.event_names << "free_mem"
    t.save

    t = Tag.new
    t.name = "TESTwebs"
    t.event_sources << "TESTweb01"
    t.event_sources << "TESTweb04"
    t.event_names << "cpu_load"
    t.event_names << "free_space"
    t.save

    t = Tag.new
    t.name = "TESTother"
    t.event_sources << "TESTother01"
    t.event_sources << "TESTother04"
    t.event_names << "cpu_load"
    t.event_names << "free_space"
    t.event_names << "mojo"
    t.save

    t = Tag.new
    t.name = "TESTmeta"
    t.tags << "TESTcrons"
    t.tags << "TESTwebs"
    t.save

    t = Tag.new
    t.name = "TESTmetaWithSourcesAndNames"
    t.tags << "TESTcrons"
    t.tags << "TESTwebs"
    t.event_sources << "source_for_meta"
    t.event_names << "name_for_meta1"
    t.event_names << "name_for_meta2"
    t.save
  end

  teardown do
    tags = Tag.by_name(:key => "TESTcrons")
    tags.each do |tag|
      t = Tag.find(tag["_id"])
      t.destroy
    end

    tags = Tag.by_name(:key => "TESTwebs")
    tags.each do |tag|
      t = Tag.find(tag["_id"])
      t.destroy
    end

    tags = Tag.by_name(:key => "TESTother")
    tags.each do |tag|
      t = Tag.find(tag["_id"])
      t.destroy
    end

    tags = Tag.by_name(:key => "TESTmeta")
    tags.each do |tag|
      t = Tag.find(tag["_id"])
      t.destroy
    end

    tags = Tag.by_name(:key => "TESTmetaWithSourcesAndNames")
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
  
  test "must return array with names" do
    actual = Tag.names_for_tagname("TESTcrons")
    expected = ["cpu_load", "free_mem"]

    assert_equal(expected, actual)
  end

  test "must return array with sources for metatag name" do
    actual = Tag.sources_for_tagname("TESTmeta")
    expected = ["TESTcron01", "TESTcron02", "TESTweb01", "TESTweb04"]

    assert_equal(expected, actual)
  end

  test "must return array with names for metatag name" do
    actual = Tag.names_for_tagname("TESTmeta")
    expected = ["cpu_load", "free_mem", "free_space"]

    assert_equal(expected, actual)
  end

  test "must return array with sources for metatag instance" do
    t = Tag.by_name(:key => "TESTmeta")
    t = Tag.find(t[0]["_id"])
    actual = t.resolved_event_sources
    expected = ["TESTcron01", "TESTcron02", "TESTweb01", "TESTweb04"]

    assert_equal(expected, actual)
  end

  test "must return array with names for metatag instance" do
    t = Tag.by_name(:key => "TESTmeta")
    t = Tag.find(t[0]["_id"])
    actual = t.resolved_event_names
    expected = ["cpu_load", "free_mem", "free_space"]

    assert_equal(expected, actual)
  end

  test "must return array with sources for TESTmetaWithSourcesAndNames instance" do
    t = Tag.by_name(:key => "TESTmetaWithSourcesAndNames")
    t = Tag.find(t[0]["_id"])
    actual = t.resolved_event_sources
    expected = ["source_for_meta", "TESTcron01", "TESTcron02", "TESTweb01", "TESTweb04"]

    assert_equal(expected, actual)
  end

  test "must return array with names for TESTmetaWithSourcesAndNames instance" do
    t = Tag.by_name(:key => "TESTmetaWithSourcesAndNames")
    t = Tag.find(t[0]["_id"])
    actual = t.resolved_event_names
    expected = ["name_for_meta1", "name_for_meta2", "cpu_load", "free_mem", "free_space"]

    assert_equal(expected, actual)
  end

  test "can't create metatag with non-existing tag(s)" do
    assert_raise (Exception) do
      t = Tag.new
      t.tags << "idefinitelydonotexist"
      t.save
    end
  end

end
