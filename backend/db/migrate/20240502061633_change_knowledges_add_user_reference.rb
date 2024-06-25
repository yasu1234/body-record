class ChangeKnowledgesAddUserReference < ActiveRecord::Migration[7.0]
  def change
    remove_column :knowledges, :create_user_id
    add_reference :knowledges, :user, null: false, foreign_key: true
    remove_column :knowledges, :create_date
  end
end
