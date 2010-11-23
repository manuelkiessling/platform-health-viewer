class FramesController < ApplicationController

  def index
    @screen = Screen.find(params[:screen_id])
    @frames = @screen.frames
  end

end
