class AddAttributeToChildren < ActiveRecord::Migration
  def change
    add_column :children, :parent2_id, :integer
    add_column :children, :parent3_id, :integer
  end
end
