class CreateMaterials < ActiveRecord::Migration[7.2]
  def change
    create_table :materials do |t|
      t.string :name, null: false
      t.bigint :user_id
      t.bigint :team_id
      t.timestamps
    end

    add_index :materials, :user_id
    add_index :materials, :team_id
    add_index :materials, [:name, :team_id, :user_id], unique: true
    add_foreign_key :materials, :users
    add_foreign_key :materials, :teams
  end
end
