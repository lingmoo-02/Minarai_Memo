class CreateNotes < ActiveRecord::Migration[7.2]
  def change
    return if ActiveRecord::Base.connection.table_exists?(:notes)
    
    create_table :notes do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :body

      t.timestamps
    end
  end
end
