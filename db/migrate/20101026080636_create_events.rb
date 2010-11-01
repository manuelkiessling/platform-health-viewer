class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.column :event_type, :integer
      t.column :value, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
