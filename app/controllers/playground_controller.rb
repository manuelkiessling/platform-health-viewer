class PlaygroundController < ApplicationController
  def get_result
    r = Result.new
    @result = r.get_by_tagname(params[:tagname])
  end

  def find_event
    found = Event.by_source_and_name(:key => {:source => "cron02.vm.myh.int", :name => "cpu_load"})
    puts Time.now
    puts found.inspect
  end

  def create_event
    event = Event.new
    event.source = "cron01.vm.myh.int"
    event.name = "cpu_load"
    event.value = rand.to_s
    event.timestamp = Time.now.to_i
    event.save!
  end

  def create_other_events
    event = Event.new
    event.source = "cron02.vm.myh.int"
    event.name = "cpu_load"
    event.value = rand.to_s
    event.timestamp = Time.now.to_i
    event.save!

    event = Event.new
    event.source = "cron02.vm.myh.int"
    event.name = "free_ram"
    event.value = rand.to_s
    event.timestamp = Time.now.to_i
    event.save!

    event = Event.new
    event.source = "cron03.vm.myh.int"
    event.name = "free_ram"
    event.value = rand.to_s
    event.timestamp = Time.now.to_i
    event.save!

    event = Event.new
    event.source = "cron01.vm.myh.int"
    event.name = "free_ram"
    event.value = rand.to_s
    event.timestamp = Time.now.to_i
    event.save!

    event = Event.new
    event.source = "cron01.vm.myh.int"
    event.name = "cpu_load"
    event.value = rand.to_s
    event.timestamp = Time.now.to_i
    event.save!
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
