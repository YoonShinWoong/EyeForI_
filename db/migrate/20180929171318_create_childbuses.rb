class CreateChildbuses < ActiveRecord::Migration
  def change
    create_table :childbuses do |t|
      t.integer :child_id
      t.integer :parent_id
      t.string :boarding
      t.time :boardingtime

      t.timestamps null: false
    end
  end
end
