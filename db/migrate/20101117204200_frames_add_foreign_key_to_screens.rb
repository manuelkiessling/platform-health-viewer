class FramesAddForeignKeyToScreens < ActiveRecord::Migration
  def self.up
    add_column :frames, :screen_id, :integer
    add_index :frames, :screen_id
  end

  def self.down
    remove_column("frames", "screen_id")
  end
end
