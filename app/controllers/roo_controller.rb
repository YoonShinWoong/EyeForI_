class RooController < ApplicationController

    require 'roo'
    
    # seed 파일에서 일부만 생성하는 것으로 변경됨, 사용 하지 않음.
    def danger
        # 서울광역시 엑셀 데이터
        xlsx = Roo::Excelx.new("./seoul_test.xlsx")
        # 전체 데이터 2 ~ 2083 중 일부만 시드생성
        (151..300).each do |i|
            @danger = Danger.new
            
            @danger.controlnumber = xlsx.cell(i, 'A')
            @danger.phone = xlsx.cell(i, 'B')
            address = xlsx.cell(i, 'C')
            @danger.zipcode = xlsx.cell(i, 'D')
            @danger.name = xlsx.cell(i, 'E')
            @danger.category = xlsx.cell(i, 'F')
            
            # () 버리기
            strStart = address.index('(')
            @danger.address = address[0..(strStart-1)]
            
            res = Naver::Map.geocode(query: @danger.address)
            # 좌표정보 X와 Y는 위도와 경도가 아니라
            # 중부원점TM(EPSG:2097) 좌표계에 따른 해당위치의 좌표정보이다.
            @danger.x = res.x
            @danger.y = res.y
            @danger.save
        end
    end
end

