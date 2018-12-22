class CreateRegions < ActiveRecord::Migration
  def change
    create_table :regions do |t|
      t.string :sidoname
      t.string :sigunname
      t.integer :arcode

      t.timestamps null: false
    end
  end
end
