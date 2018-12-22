class AddAttributeToKakaos < ActiveRecord::Migration
  def change
    add_column :kakaos, :login, :boolean
  end
end
