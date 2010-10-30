class CreateQueueEvents < ActiveRecord::Migration
  def self.up
    create_table :queue_events do |t|
      t.column :source, :string
      t.column :name, :string
      t.column :value, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :queue_events
  end
end
