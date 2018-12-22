class AddAttributetwoToKakaos < ActiveRecord::Migration
  def change
    add_column :kakaos, :lastQuestion, :string
  end
end
