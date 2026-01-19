class AddTeamIdToTags < ActiveRecord::Migration[7.2]
  def change
    add_reference :tags, :team, foreign_key: true, null: true
    remove_index :tags, :name
    add_index :tags, [:name, :team_id], unique: true
  end
end
