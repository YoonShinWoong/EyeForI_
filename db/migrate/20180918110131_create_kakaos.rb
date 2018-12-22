class CreateKakaos < ActiveRecord::Migration
  def change
    create_table :kakaos do |t|
      t.string :user_key
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
