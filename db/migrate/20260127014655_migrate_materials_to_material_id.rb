class MigrateMaterialsToMaterialId < ActiveRecord::Migration[7.2]
  def up
    Note.where.not(materials: [nil, '']).find_each do |note|
      material = Material.find_or_create_by!(
        name: note.materials,
        user_id: note.user_id,
        team_id: note.team_id
      )
      note.update_column(:material_id, material.id)
    end
  end

  def down
    Note.where.not(material_id: nil).find_each do |note|
      note.update_column(:materials, note.material.name) if note.material
    end
  end
end
