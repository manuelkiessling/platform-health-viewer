class Frame < ActiveRecord::Base
  belongs_to :screen
  validates_presence_of :screen, :tag
end
