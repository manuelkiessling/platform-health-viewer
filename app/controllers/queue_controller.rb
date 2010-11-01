class QueueController < ApplicationController
  def show
    @queue_events = QueueEvent.all
  end
end
