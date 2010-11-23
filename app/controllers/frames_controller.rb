class FramesController < ApplicationController

  def index
    @screen = Screen.find(params[:screen_id])
    @frames = @screen.frames
    respond_to do |format|
      format.html
      format.xml { render :xml => @frames.to_xml }
      format.json { render :json => @frames.to_json }
    end
  end

end
