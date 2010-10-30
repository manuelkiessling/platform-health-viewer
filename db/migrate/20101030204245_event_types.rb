class EventTypes < ActiveRecord::Migration
  def self.up
    add_index :event_types, [:source, :name]
  end

  def self.down
    remove_index :event_types, [:source, :name]
  end
end
