class AddArrayToKindergarden < ActiveRecord::Migration
  def change
    add_column :kindergardens, :frequentArr, :integer, array: true, default: []
    add_column :kindergardens, :dangerArr, :integer, array: true, default: []
    add_column :kindergardens, :schoolArr, :integer, array: true, default: []
  end
end
