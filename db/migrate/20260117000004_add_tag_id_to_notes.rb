class AddTagIdToNotes < ActiveRecord::Migration[7.2]
  def change
    add_reference :notes, :tag, foreign_key: true, null: true
  end
end
