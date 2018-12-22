require '20180918111401_create_kindergardens.rb'
@kinder = Kindergarden.where("crname like ?", "%어린이%")
type(@kinder)