class CreateRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :records do |t|
      t.integer :user_id, null: false
      t.float :weight
      t.float :fat_percentage
      t.datetime :date
      t.boolean :open_flg
      t.string :memo
      t.timestamps
    end
  end
end
