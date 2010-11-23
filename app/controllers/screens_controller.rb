class ScreensController < ApplicationController

  def show
    screen = Screen.find(params[:id])
    @frames = screen.frames
    @new_frame = Frame.new
    @new_frame.screen = screen
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

  def update_frame
    @frame = Frame.find(params[:frame][:id])
    if (params[:frame][:top]) then @frame.top = params[:frame][:top] end
    if (params[:frame][:left]) then @frame.left = params[:frame][:left] end
    if (params[:frame][:height]) then @frame.height = params[:frame][:height] end
    if (params[:frame][:width]) then @frame.width = params[:frame][:width] end
    @frame.save

    respond_to do |format|
      format.html { redirect_to :action => 'show', :name => @frame.screen.name }
      format.js
    end
  end

end
