class FramesController < ApplicationController

  def index
    @screen = Screen.find(params[:screen_id])
    @frames = @screen.frames
    @starttime = nil
    @timerange = 3600
    @timerange = params[:timerange].to_i unless params[:timerange].nil?
    respond_to do |format|
      format.html
      format.xml { render :xml => @frames.to_xml }
      format.json { render :json => @frames.to_json }
    end
  end

  def create
    begin
      f = Frame.new(params[:frame])
      f.top = 10
      f.left = 10
      f.screen = Screen.find(params[:screen_id])
      f.save
    rescue Exception => e
      flash[:error] = "Error: " + e.message
    end
    respond_to do |format|
      format.html { redirect_to screen_frames_path }
      format.js
    end
  end

  def update
    @frame = Frame.find(params[:id])
    if (params[:frame][:top]) then @frame.top = params[:frame][:top] end
    if (params[:frame][:left]) then @frame.left = params[:frame][:left] end
    if (params[:frame][:height]) then @frame.height = params[:frame][:height] end
    if (params[:frame][:width]) then @frame.width = params[:frame][:width] end
    @frame.save

    respond_to do |format|
      format.html { redirect_to screen_frames_path }
      format.js { head :ok }
    end
  end

  def destroy
    frame = Frame.find(params[:id])
    frame.delete

    respond_to do |format|
      format.html { redirect_to screen_frames_path }
      format.js
    end
  end

end
