class EventTypesUniqueKeyOnSourceAndName < ActiveRecord::Migration
  def self.up
    remove_index :event_types, [:source, :name]
    add_index :event_types, [:source, :name], :unique => true
  end

  def self.down
    remove_index :event_types, [:source, :name]
    add_index :event_types, [:source, :name]
  end
end
