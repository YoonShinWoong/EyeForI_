class AddSafetygradeToKindergarden < ActiveRecord::Migration
  def change
    add_column :kindergardens, :safetyGrade, :string
  end
end
