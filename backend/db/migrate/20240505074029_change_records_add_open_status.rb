class ChangeRecordsAddOpenStatus < ActiveRecord::Migration[7.0]
  def change
    remove_column :records, :open_flg
    add_column :records, :open_status, :integer
  end
end
