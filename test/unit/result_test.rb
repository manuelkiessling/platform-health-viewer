require "test/unit"

class ResultTest < Test::Unit::TestCase

  def setup
    teardown

    et = EventType.new
    et.source = "TESTcron01"
    et.name = "cpu_load"
    et.save

    e = Event.new
    e.event_type = et
    e.value = "0.11"
    e.save

    e = Event.new
    e.event_type = et
    e.value = "0.12"
    e.save

    et = EventType.new
    et.source = "TESTcron02"
    et.name = "cpu_load"
    et.save

    e = Event.new
    e.event_type = et
    e.value = "0.21"
    e.save

    e = Event.new
    e.event_type = et
    e.value = "0.22"
    e.save

    et = EventType.new
    et.source = "TESTcron02"
    et.name = "free_mem"
    et.save

    e = Event.new
    e.event_type = et
    e.value = "21%"
    e.save

    e = Event.new
    e.event_type = et
    e.value = "22%"
    e.save
  end

  def teardown
    ets = EventType.all
    ets.each do |et|
      et.destroy
    end

    es = Event.all
    es.each do |e|
      e.destroy
    end
  end

  def test_find_with_2_sources_and_1_name
    actual = Result.find(["TESTcron01", "TESTcron02"], ["free_mem"], EventType)

    expected = [{"source" => "TESTcron02", "name" => "free_mem", "value" => "21%"},
                {"source" => "TESTcron02", "name" => "free_mem", "value" => "22%"}
               ]

    assert_equal(expected, actual)
  end

  def test_find_with_1_source_and_1_name_nonexistant
    actual = Result.find(["TESTcron01"], ["free_mem"], EventType)

    expected = []

    assert_equal(expected, actual)
  end

  def test_find_with_2_sources_and_no_name
    actual = Result.find(["TESTcron01", "TESTcron02"], [], EventType)

    expected = [{"source" => "TESTcron01", "name" => "cpu_load", "value" => "0.11"},
                {"source" => "TESTcron01", "name" => "cpu_load", "value" => "0.12"},
                {"source" => "TESTcron02", "name" => "cpu_load", "value" => "0.21"},
                {"source" => "TESTcron02", "name" => "cpu_load", "value" => "0.22"},
                {"source" => "TESTcron02", "name" => "free_mem", "value" => "21%"},
                {"source" => "TESTcron02", "name" => "free_mem", "value" => "22%"}
               ]

    assert_equal(expected, actual)
  end

  def test_find_with_no_sources_and_1_name
    actual = Result.find([], ["cpu_load"], EventType)

    expected = [{"source" => "TESTcron01", "name" => "cpu_load", "value" => "0.11"},
                {"source" => "TESTcron01", "name" => "cpu_load", "value" => "0.12"},
                {"source" => "TESTcron02", "name" => "cpu_load", "value" => "0.21"},
                {"source" => "TESTcron02", "name" => "cpu_load", "value" => "0.22"}
               ]

    assert_equal(expected, actual)
  end

  def test_find_with_no_sources_and_2_names
    actual = Result.find([], ["cpu_load", "free_mem"], EventType)

    expected = [{"source" => "TESTcron01", "name" => "cpu_load", "value" => "0.11"},
                {"source" => "TESTcron01", "name" => "cpu_load", "value" => "0.12"},
                {"source" => "TESTcron02", "name" => "cpu_load", "value" => "0.21"},
                {"source" => "TESTcron02", "name" => "cpu_load", "value" => "0.22"},
                {"source" => "TESTcron02", "name" => "free_mem", "value" => "21%"},
                {"source" => "TESTcron02", "name" => "free_mem", "value" => "22%"}
               ]

    assert_equal(expected, actual)
  end

  def test_find_with_2_sources_and_2_names
    actual = Result.find(["TESTcron01", "TESTcron02"], ["cpu_load", "free_mem"], EventType)

    expected = [{"source" => "TESTcron01", "name" => "cpu_load", "value" => "0.11"},
                {"source" => "TESTcron01", "name" => "cpu_load", "value" => "0.12"},
                {"source" => "TESTcron02", "name" => "cpu_load", "value" => "0.21"},
                {"source" => "TESTcron02", "name" => "cpu_load", "value" => "0.22"},
                {"source" => "TESTcron02", "name" => "free_mem", "value" => "21%"},
                {"source" => "TESTcron02", "name" => "free_mem", "value" => "22%"}
               ]

    assert_equal(expected, actual)
  end

end
