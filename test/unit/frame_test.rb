require 'test_helper'

class FrameTest < ActiveSupport::TestCase

  test "can't set non-existing tag" do
    f = Frame.new
    assert_raise (Exception) do
      f.tag = "idefinitelydonotexist"
    end
  end

end
