class CreateDangers < ActiveRecord::Migration
  def change
    create_table :dangers do |t|
      t.string :controlnumber
      t.string :phone
      t.string :address
      t.integer :zipcode
      t.string :name
      t.string :category
      t.float :x
      t.float :y
      
      t.timestamps null: false
    end
  end
end