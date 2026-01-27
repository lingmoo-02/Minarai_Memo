class AddMaterialsToNotes < ActiveRecord::Migration[7.2]
  def up
    add_column :notes, :materials, :text

    # 既存データの移行: material_idからmaterial.nameをコピー
    Note.includes(:material).where.not(material_id: nil).find_each do |note|
      note.update_column(:materials, note.material.name) if note.material
    end
  end

  def down
    remove_column :notes, :materials
  end
end
