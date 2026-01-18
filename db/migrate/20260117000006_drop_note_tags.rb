class DropNoteTags < ActiveRecord::Migration[7.2]
  def up
    drop_table :note_tags
  end

  def down
    create_table :note_tags do |t|
      t.references :note, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true
      t.timestamps
    end
    add_index :note_tags, [:note_id, :tag_id], unique: true
  end
end
