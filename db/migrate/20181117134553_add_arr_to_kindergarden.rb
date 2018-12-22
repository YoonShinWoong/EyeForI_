class AddArrToKindergarden < ActiveRecord::Migration
  def change
    add_column :kindergardens, :freArr, :integer, array: true, default: []
    add_column :kindergardens, :danArr, :integer, array: true, default: []
    add_column :kindergardens, :schArr, :integer, array: true, default: []
  end
end
