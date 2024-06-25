class CreateContacts < ActiveRecord::Migration[7.0]
  def change
    create_table :contacts do |t|
      t.integer :user_id
      t.integer :status
      t.string :content

      t.timestamps
    end
  end
end
