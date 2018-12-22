class AddArrthreeToKindergarden < ActiveRecord::Migration
  def change
    add_column :kindergardens, :fre, :string
    add_column :kindergardens, :dan, :string
    add_column :kindergardens, :sch, :string
  end
end
