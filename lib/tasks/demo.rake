namespace :demodata do
    task:remove => :environment do
      event_types = EventType.find_by_sources_and_names(["demoserver01", "demoserver02"], [])
      event_types.each do |event_type|
        event_type.events.all.each do |event|
          event.delete
        end
        event_type.delete
      end

      frames = Frame.all(:conditions=> {:tag => "DEMO-Tag"})
      frames.each do |frame|
        frame.delete
      end

      Tag.find_by_name("DemoTag").destroy

      puts "Demo data removed."
    end

    task:create => :environment do
      Rake::Task["remove"].invoke
      
      et1 = EventType.create(:source => "demoserver01", :name => "cpu_load")
      et2 = EventType.create(:source => "demoserver02", :name => "cpu_load")

      t = Time.zone.now

      i = 10000
      10000.times do
        Event.new do |e|
          e.value = rand
          e.event_type = et1
          e.created_at = t - i
          e.save
        end
        i = i - 1
      end

      i = 10000
      10000.times do
        if (rand(3) == 2) then
          Event.new do |e|
            e.value = rand - 0.5
            e.value = 0.04 unless e.value >= 0.0
            e.event_type = et2
            e.created_at = t - i
            e.save
          end
        end
        i = i - 1
      end

      Rake::Task["queue:convert"].invoke
      
      tag = Tag.new
      tag.name = "DemoTag"
      tag.event_sources = ["demoserver01", "demoserver02"]
      tag.event_names = ["cpu_load"]
      tag.save

      frame = Frame.create(:screen => Screen.find(1), :tag => tag, :width => 600, :height => 300, :top => 120, :left => 40)
      
      puts "Demo data created."
  end
end
