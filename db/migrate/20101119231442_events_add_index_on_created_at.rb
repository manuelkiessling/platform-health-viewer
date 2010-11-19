class EventsAddIndexOnCreatedAt < ActiveRecord::Migration
  def self.up
    add_index :events, :value
  end

  def self.down
    remove_index :events, :value
  end
end
