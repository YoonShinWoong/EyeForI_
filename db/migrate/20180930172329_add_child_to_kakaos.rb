class AddChildToKakaos < ActiveRecord::Migration
  def change
    add_column :kakaos, :selChild, :string
  end
end
