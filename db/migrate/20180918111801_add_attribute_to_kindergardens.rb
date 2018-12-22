class AddAttributeToKindergardens < ActiveRecord::Migration
  def change
    add_column :kindergardens, :medecine, :string
    add_column :kindergardens, :ramp, :stringparmas
    add_column :kindergardens, :healthedu, :string
    add_column :kindergardens, :safetyedu, :string
    add_column :kindergardens, :healthcheck, :string
    add_column :kindergardens, :vaccination, :string
  end
end
