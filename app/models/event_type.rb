class EventType < ActiveRecord::Base
  has_many :events
  validates_presence_of :source, :name
end
