require 'simple_xlsx_reader'

workbook = SimpleXlsxReader.open './seoul_schoolZone.xlsx'
worksheets = workbook.sheets
puts "Found #{worksheets.count} worksheets"

worksheets.each do |worksheet|
  num_rows = 0
  worksheet.rows.each do |row|
    row_cells = row
    puts "#{row_cells[1]}" # spotname
    puts "#{row_cells[5]}" # x_crd
    puts "#{row_cells[4]}" # y_crd
    num_rows += 1
  end
end