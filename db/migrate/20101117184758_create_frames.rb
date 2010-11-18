class CreateFrames < ActiveRecord::Migration
  def self.up
    create_table :frames do |t|
      t.column :left, :integer
      t.column :top, :integer
      t.column :width, :integer
      t.column :height, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :frames
  end
end
