class AddArrtwoToKindergarden < ActiveRecord::Migration
  def change
    add_column :kindergardens, :fArr,:integer, array: true
    add_column :kindergardens, :dArr,:integer, array: true
    add_column :kindergardens, :sArr,:integer, array: true
  end
end
