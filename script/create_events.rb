Event.delete_all
EventType.delete_all

et1 = EventType.new
et1.source = "cron01"
et1.name = "cpu_load"

et2 = EventType.new
et2.source = "cron02"
et2.name = "cpu_load"

t = Time.zone.parse("2010-11-19 11:55:00")

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
