class Events < ActiveRecord::Migration
  def self.up
    add_index :events, :event_type
  end

  def self.down
    remove_index :events, :event_type
  end
end
