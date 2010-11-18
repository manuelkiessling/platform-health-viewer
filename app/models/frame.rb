class Frame < ActiveRecord::Base
  belongs_to :screen
  has_one :tag
  validates_presence_of :screen, :tag
end
