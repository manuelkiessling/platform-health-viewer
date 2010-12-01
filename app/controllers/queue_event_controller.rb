class QueueEventController < ApplicationController
  skip_before_filter :verify_authenticity_token
  
  def create
    qe = QueueEvent.new(params[:event])
    qe.value = params[:event][:value].to_f
    qe.created_at = Time.zone.now
    qe.save

    respond_to do |format|
      format.html { render :json => qe.to_json }
      format.xml { render :xml => @tags.to_xml }
      format.json { render :json => qe.to_json }
    end
  end

end
