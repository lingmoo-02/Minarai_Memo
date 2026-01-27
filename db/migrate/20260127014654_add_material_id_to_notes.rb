class AddMaterialIdToNotes < ActiveRecord::Migration[7.2]
  def change
    add_reference :notes, :material, foreign_key: true
  end
end
