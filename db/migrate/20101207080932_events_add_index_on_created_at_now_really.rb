class EventsAddIndexOnCreatedAtNowReally < ActiveRecord::Migration
    def self.up
      add_index :events, [:event_type_id, :created_at]
    end

    def self.down
      remove_index :events, [:event_type_id, :created_at]
    end
end
