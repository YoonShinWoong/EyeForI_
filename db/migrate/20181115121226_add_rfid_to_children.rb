class AddRfidToChildren < ActiveRecord::Migration
  def change
    add_column :children, :rfid, :string
  end
end
