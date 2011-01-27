class Frame < ActiveRecord::Base
  belongs_to :screen
  validates_presence_of :screen, :tag

  def tag=(tagname)
    tag = Tag.find_by_name(tagname)
    if (tag.nil?) then
      raise Exception.new("No tag by the name '" + tagname + "'")
    end
    super
  end

end
