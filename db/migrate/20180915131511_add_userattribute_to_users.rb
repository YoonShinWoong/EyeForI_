class AddUserattributeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :usertype, :string
    add_column :users, :username, :string
    add_column :users, :gender, :string
    add_column :users, :age, :integer
    add_column :users, :telephone, :string
    add_column :users, :kindergarden_id, :integer
  end
end
