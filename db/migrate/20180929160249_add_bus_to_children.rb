class AddBusToChildren < ActiveRecord::Migration
  def change
    add_column :children, :boarding, :string
    add_column :children, :boardingtime, :time
  end
end
