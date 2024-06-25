class ChangeProfilesAddUserReference < ActiveRecord::Migration[7.0]
  def change
    remove_column :profiles, :user_id
    add_reference :profiles, :user, null: false, foreign_key: true
  end
end
