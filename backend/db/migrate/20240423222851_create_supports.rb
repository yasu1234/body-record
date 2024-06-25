class CreateSupports < ActiveRecord::Migration[7.0]
  def change
    create_table :supports do |t|
      t.references :user, foreign_key: true
      t.references :support, foreign_key: { to_table: :users }
      t.timestamps
      
      t.index %i[ user_id support_id ], unique: true
    end
  end
end
