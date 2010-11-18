class FramesAddTagName < ActiveRecord::Migration
  def self.up
    add_column :frames, :tag, :string
  end

  def self.down
    remove_column :frames, :tag
  end
end
