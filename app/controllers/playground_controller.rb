class PlaygroundController < ApplicationController

  def create_queue_events
    event = QueueEvent.new
    event.source = "cron01.vm.myh.int"
    event.name = "cpu_load"
    event.value = rand.to_s
    event.save!

    event = QueueEvent.new
    event.source = "cron02.vm.myh.int"
    event.name = "free_ram"
    event.value = rand.to_s
    event.save!
  end

  def create_dummy_data
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

    tag = Tag.new
    tag.name = "Crons all"
    tag.event_sources << "TESTcron01"
    tag.event_sources << "TESTcron02"
    tag.save

    tag = Tag.new
    tag.name = "cpu_load all"
    tag.event_names << "cpu_load"
    tag.save

    tag = Tag.new
    tag.name = "cpu_load crons"
    tag.event_sources << "TESTcron01"
    tag.event_sources << "TESTcron02"
    tag.event_names << "cpu_load"
    tag.save

  end

  def create_tag
    tag = Tag.new
    tag.name = "CPU Crons"
    tag.event_sources << "cron01.vm.myh.int"
    tag.event_sources << "cron02.vm.myh.int"
    tag.event_names << "cpu_load"
    tag.save!
  end

end
