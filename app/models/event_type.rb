class EventType < ActiveRecord::Base
  has_many :events
  validates_presence_of :source, :name

  def self.find_by_sources_and_names(sources, names)
    results = []
      if (sources.empty?) then
        event_types = self.all(:conditions => { :name => names })
      else
        if (names.empty?) then
          event_types = self.all(:conditions => { :source => sources })
        else
          event_types = self.all(:conditions => { :source => sources, :name => names })
        end
      end
      Event.all(:conditions => { :event_type_id => event_types }, :order => "id DESC").each do |event|
        results = results | [ "created_at" => event.created_at.to_s, "source" => self.find(event.event_type_id).source, "name" => self.find(event.event_type_id).name, "value" => event.value ]
      end
    results
  end

end
