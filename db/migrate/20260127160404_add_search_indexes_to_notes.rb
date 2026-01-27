class AddSearchIndexesToNotes < ActiveRecord::Migration[7.2]
  def up
    # PostgreSQLのpg_trgm拡張を有効化（トライグラム検索用）
    enable_extension 'pg_trgm' unless extension_enabled?('pg_trgm')

    # タイトルの部分一致検索を高速化（GiNインデックス）
    add_index :notes, :title, using: :gin, opclass: :gin_trgm_ops,
              name: 'index_notes_on_title_trgm'

    # user_id + created_at の複合インデックス（日付範囲検索の高速化）
    add_index :notes, [:user_id, :created_at],
              name: 'index_notes_on_user_id_and_created_at'
  end

  def down
    remove_index :notes, name: 'index_notes_on_title_trgm'
    remove_index :notes, name: 'index_notes_on_user_id_and_created_at'
    # pg_trgm拡張は削除しない（他で使用されている可能性）
  end
end
