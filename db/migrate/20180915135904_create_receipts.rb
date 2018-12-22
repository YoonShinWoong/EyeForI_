class CreateReceipts < ActiveRecord::Migration
  def change
    create_table :receipts do |t|
      t.integer :user_id
      t.integer :applicant_id
      t.integer :child_id

      t.timestamps null: false
    end
  end
end
