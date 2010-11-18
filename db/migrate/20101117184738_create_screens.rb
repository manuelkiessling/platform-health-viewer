class CreateScreens < ActiveRecord::Migration
  def self.up
    create_table :screens do |t|
      t.column :name, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :screens
  end
end
