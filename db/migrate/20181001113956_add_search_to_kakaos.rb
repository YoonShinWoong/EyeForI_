class AddSearchToKakaos < ActiveRecord::Migration
  def change
    add_column :kakaos, :sido, :string
    add_column :kakaos, :sigungu, :string
    add_column :kakaos, :name, :string
  end
end
