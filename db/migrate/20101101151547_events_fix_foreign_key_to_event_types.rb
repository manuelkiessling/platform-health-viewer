class EventsFixForeignKeyToEventTypes < ActiveRecord::Migration
  def self.up
    rename_column("events", "event_type", "event_type_id")
  end

  def self.down
    rename_column("events", "event_type_id", "event_type")
  end
end
