class EventTypesController < ApplicationController

  def index
    ets = EventType.all(:order => 'source ASC')

    respond_to do |format|
      format.json { render :json => ets.to_json }
    end
  end

end
