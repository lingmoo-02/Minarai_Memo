class AddNoteImageToNotes < ActiveRecord::Migration[7.2]
  def change
    add_column :notes, :note_image, :string
  end
end
