class Event < ActiveRecord::Base
  belongs_to :event_type
  validates_presence_of :event_type
end
