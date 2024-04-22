class CreateBookmarks < ActiveRecord::Migration[7.0]
  def change
    create_table :bookmarks do |t|
      t.references :user, null: false, foreign_key: true
      t.references :knowledge, null: false, foreign_key: true

      t.timestamps

      t.index %i[user_id knowledge_id], unique: true
    end
  end
end
