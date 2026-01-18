class MigrateNoteTagsToNotes < ActiveRecord::Migration[7.2]
  def up
    # note_tagsから最初のタグをnotesに移行
    # 各ノートに対して最初のタグ（最もIDが小さいタグ）を割り当てる
    execute <<-SQL
      UPDATE notes
      SET tag_id = (
        SELECT tag_id FROM note_tags
        WHERE note_tags.note_id = notes.id
        ORDER BY note_tags.id ASC
        LIMIT 1
      )
      WHERE EXISTS (
        SELECT 1 FROM note_tags
        WHERE note_tags.note_id = notes.id
      )
      AND tag_id IS NULL;
    SQL
  end

  def down
    # ロールバック時は何もしない（note_tagsテーブル削除前なので）
  end
end
