class CreateKnowledges < ActiveRecord::Migration[7.0]
  def change
    create_table :knowledges do |t|
      t.integer :create_user_id, null: false
      t.string :title, null: false
      t.string :content
      t.datetime :create_date
      t.timestamps
    end
  end
end
