class CreateProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :profiles do |t|
      t.integer :user_id, null: false
      t.string :profile
      t.float :goal_weight
      t.float :goal_fat_percentage
      t.timestamps
    end
  end
end
