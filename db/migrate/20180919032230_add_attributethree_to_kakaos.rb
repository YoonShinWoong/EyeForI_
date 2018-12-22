class AddAttributethreeToKakaos < ActiveRecord::Migration
  def change
    add_column :kakaos, :email, :string
    add_column :kakaos, :password, :string
  end
end
