class AddTeamIdToNotes < ActiveRecord::Migration[7.2]
  def change
    add_reference :notes, :team, foreign_key: true, null: true
    add_index :notes, [:team_id, :created_at]
  end
end
