class RemoveMaterialsFromNotes < ActiveRecord::Migration[7.2]
  def change
    remove_column :notes, :materials, :string
  end
end
