class QueueEvent < ActiveRecord::Base
  validates_presence_of :source, :name, :value
end
