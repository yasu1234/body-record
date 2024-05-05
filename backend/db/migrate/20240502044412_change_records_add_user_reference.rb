class ChangeRecordsAddUserReference < ActiveRecord::Migration[7.0]
  def change
    remove_column :records, :user_id
    add_reference :records, :user, null: false, foreign_key: true
  end
end
