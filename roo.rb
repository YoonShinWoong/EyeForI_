require 'roo'

# 대구광역시 엑셀 데이터
xlsx = Roo::Excelx.new("./daegu.xlsx")
# 2번부터 1833번째 줄 까지 파싱
(2..499).each do |i|
    @danger = Danger.new
    
    @danger.controlnumber = xlsx.cell(i, 'A')
    @danger.phone = xlsx.cell(i, 'B')
    @danger.address = xlsx.cell(i, 'C')
    @danger.zipcode = xlsx.cell(i, 'D')
    @danger.name = xlsx.cell(i, 'E')
    @danger.category = xlsx.cell(i, 'F')
    
    # 좌표정보 X와 Y는 위도와 경도가 아니라
    # 중부원점TM(EPSG:2097) 좌표계에 따른 해당위치의 좌표정보이다.
    @danger.x = res.x
    @danger.y = res.y
end