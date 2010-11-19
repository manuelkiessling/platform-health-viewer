class ScreenController < ApplicationController

  def show
    screen = Screen.find_by_name(params[:name])
    @frames = screen.frames
  end

  def add_frame
    @frame = Frame.new
    @frame.top = 0
    @frame.left = 0
    @frame.height = 200
    @frame.width = 200
    @frame.tag = params[:frame][:tag]
    @frame.screen_id = params[:frame][:screen_id]
    @frame.save

    respond_to do |format|
      format.html { redirect_to screen_path }
      format.js
    end
  end

end
