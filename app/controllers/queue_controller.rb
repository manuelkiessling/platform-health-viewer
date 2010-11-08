class QueueController < ApplicationController

  include ActionView::Helpers::PrototypeHelper
  
  def events
    if params[:q] then
      @queue_events = QueueEvent.find(:all, :conditions => { :name => params[:q] } )
    else
      @queue_events = QueueEvent.all
    end


    respond_to do |format|
      format.html { render :layout=>"empty" }
      format.xml { render :xml => @queue_events }
      format.json { render :json => @queue_events }
    end

  end

  def search

  end
end
