class QueueEventController < ApplicationController
  skip_before_filter :verify_authenticity_token
  
  def create
    qe = QueueEvent.new(params[:event])
    qe.value = params[:event][:value].to_f
    qe.created_at = Time.zone.now
    qe.save

    render :json => qe.to_json
  end

end
