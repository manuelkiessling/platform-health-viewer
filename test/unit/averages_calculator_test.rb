require 'test_helper'

class AveragesCalculatorTest < ActiveSupport::TestCase

  setup do
    teardown
  end

  teardown do
    Event.delete_all
    EventType.delete_all
  end

  test "get grouped and averaged event list, 5 minutes average" do
    t = Time.zone.parse("2010-11-19 11:55:00")

    et1 = EventType.create(:source => "TESTcron01", :name => "cpu_load")
    12.times do |i|
      Event.create(:value => (i + 1), :event_type => et1, :created_at => t + ((i + 1) * 60))
    end

    et2 = EventType.create(:source => "TESTcron02", :name => "cpu_load")
    12.times do |i|
      Event.create(:value => (i + 1) * 2, :event_type => et2, :created_at => t + ((i + 1) * 60))
    end

    Event.create(:value => 9999, :event_type => et2, :created_at => Time.zone.parse("2010-11-19 14:45:00"))

    expected = []
    
    expected[0] = {
      "event_type_id" => et1.id,
      "values" =>
        [ {"chunk"=>"2010-11-19 11:55:00", "value"=>2.5},
          {"chunk"=>"2010-11-19 12:00:00", "value"=>7.0},
          {"chunk"=>"2010-11-19 12:05:00", "value"=>11.0},
          {"chunk"=>"2010-11-19 12:10:00", "value"=>nil},
          {"chunk"=>"2010-11-19 12:15:00", "value"=>nil}
        ]
    }

    expected[1] = {
      "event_type_id" => et2.id,
      "values"=>
        [ {"chunk"=>"2010-11-19 11:55:00", "value"=>5.0},
          {"chunk"=>"2010-11-19 12:00:00", "value"=>14.0},
          {"chunk"=>"2010-11-19 12:05:00", "value"=>22.0},
          {"chunk"=>"2010-11-19 12:10:00", "value"=>nil},
          {"chunk"=>"2010-11-19 12:15:00", "value"=>nil}
        ]
    }

    averages_calculator = AveragesCalculator.new()
    averages = averages_calculator.calculate_for(:event_types  => [et1, et2],
                                                 :between      => Time.zone.parse("2010-11-19 11:55:32"),
                                                 :and          => Time.zone.parse("2010-11-19 12:15:00"),
                                                 :in_chunks_of => 5,
                                                 :minutes      => true)

    assert_equal(expected, averages)
  end
  
  test "get grouped and averaged event list, 10 minutes averages" do
    t = Time.zone.parse("2010-11-19 11:55:00")

    et1 = EventType.create(:source => "TESTcron01", :name => "cpu_load")
    
    Event.create(:value => 1, :event_type => et1, :created_at => Time.zone.parse("2010-11-19 11:55:12"))
    Event.create(:value => 1, :event_type => et1, :created_at => Time.zone.parse("2010-11-19 11:56:33"))
    Event.create(:value => 1, :event_type => et1, :created_at => Time.zone.parse("2010-11-19 11:57:13"))

    Event.create(:value => 10, :event_type => et1, :created_at => Time.zone.parse("2010-11-19 12:11:00"))
    Event.create(:value => 10, :event_type => et1, :created_at => Time.zone.parse("2010-11-19 12:11:01"))
    Event.create(:value => 10, :event_type => et1, :created_at => Time.zone.parse("2010-11-19 12:11:59"))

    Event.create(:value => 10, :event_type => et1, :created_at => Time.zone.parse("2010-11-19 12:13:00"))
    Event.create(:value => 10, :event_type => et1, :created_at => Time.zone.parse("2010-11-19 12:13:01"))
    Event.create(:value => 100, :event_type => et1, :created_at => Time.zone.parse("2010-11-19 12:13:59"))

    
    et2 = EventType.create(:source => "TESTcron02", :name => "cpu_load")
    
    Event.create(:value => 1, :event_type => et2, :created_at => Time.zone.parse("2010-11-19 11:55:12"))
    Event.create(:value => 1, :event_type => et2, :created_at => Time.zone.parse("2010-11-19 11:56:33"))
    Event.create(:value => 1, :event_type => et2, :created_at => Time.zone.parse("2010-11-19 11:57:13"))

    Event.create(:value => 40, :event_type => et2, :created_at => Time.zone.parse("2010-11-19 12:01:56"))
    Event.create(:value => 40, :event_type => et2, :created_at => Time.zone.parse("2010-11-19 12:03:59"))
    Event.create(:value => 40, :event_type => et2, :created_at => Time.zone.parse("2010-11-19 12:04:59"))

    Event.create(:value => 20, :event_type => et2, :created_at => Time.zone.parse("2010-11-19 12:05:00"))
    Event.create(:value => 20, :event_type => et2, :created_at => Time.zone.parse("2010-11-19 12:05:01"))
    Event.create(:value => 20, :event_type => et2, :created_at => Time.zone.parse("2010-11-19 12:09:59"))


    Event.create(:value => 9999, :event_type => et2, :created_at => Time.zone.parse("2010-11-19 14:45:00"))

    expected = []
    
    expected[0] = {
      "event_type_id" => et1.id,
      "values" =>
        [ {"chunk"=>"2010-11-19 11:50:00", "value"=>1.0},
          {"chunk"=>"2010-11-19 12:00:00", "value"=>nil},
          {"chunk"=>"2010-11-19 12:10:00", "value"=>25.0}
        ]
    }

    expected[1] = {
      "event_type_id" => et2.id,
      "values"=>
        [ {"chunk"=>"2010-11-19 11:50:00", "value"=>1.0},
          {"chunk"=>"2010-11-19 12:00:00", "value"=>30.0},
          {"chunk"=>"2010-11-19 12:10:00", "value"=>nil}
        ]
    }

    averages_calculator = AveragesCalculator.new()
    averages = averages_calculator.calculate_for(:event_types  => [et1, et2],
                                                 :between      => Time.zone.parse("2010-11-19 11:55:32"),
                                                 :and          => Time.zone.parse("2010-11-19 12:15:00"),
                                                 :in_chunks_of => 10,
                                                 :minutes      => true)

    assert_equal(expected, averages)
  end
  
end
