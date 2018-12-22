class CreateChildren < ActiveRecord::Migration
  def change
    create_table :children do |t|
      t.string :name
      t.integer :age
      t.string :gender
      t.integer :teacher_id
      t.integer :parent_id
      t.bigint :kindergarden_id
      t.string :className
      t.integer :classNumber
      t.string :image

      t.timestamps null: false
    end
  end
end
