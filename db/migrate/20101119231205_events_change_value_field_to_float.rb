class EventsChangeValueFieldToFloat < ActiveRecord::Migration
  def self.up
    change_column(:events, :value, :float)
  end

  def self.down
    change_column(:events, :value, :string)
  end
end
