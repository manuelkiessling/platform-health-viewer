require 'test_helper'

class PlaygroundControllerTest < ActionController::TestCase
  test "should get create_event" do
    get :create_event
    assert_response :success
  end

end
