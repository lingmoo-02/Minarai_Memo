class AddWorkDetailsToNotes < ActiveRecord::Migration[7.2]
  def change
    add_column :notes, :materials, :string, null: true
    add_column :notes, :work_duration, :integer, null: true
    add_column :notes, :reflection, :string, null: true
  end
end
