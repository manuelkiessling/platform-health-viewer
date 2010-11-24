class ScreensController < ApplicationController

  def show
    screen = Screen.find(params[:id])
    @frames = screen.frames
    @new_frame = Frame.new
    @new_frame.screen = screen
  end

end
