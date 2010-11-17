class EventType < ActiveRecord::Base
  has_many :events
  validates_presence_of :source, :name

  def self.find_by_sources_and_names(sources, names)
    if (sources.empty?) then
      event_types = self.all(:conditions => { :name => names })
    else
      if (names.empty?) then
        event_types = self.all(:conditions => { :source => sources })
      else
        event_types = self.all(:conditions => { :source => sources, :name => names })
      end
    end
    event_types
  end

end
