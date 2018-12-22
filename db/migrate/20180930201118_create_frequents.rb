class CreateFrequents < ActiveRecord::Migration
  def change
    create_table :frequents do |t|
      t.string :spotname
      t.float :x_crd
      t.float :y_crd
      
      t.timestamps null: false
    end
  end
end
