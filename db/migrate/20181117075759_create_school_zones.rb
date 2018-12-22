class CreateSchoolZones < ActiveRecord::Migration
  def change
    create_table :school_zones do |t|
      t.string :spotname
      t.float :x_crd
      t.float :y_crd

      t.timestamps null: false
    end
  end
end
