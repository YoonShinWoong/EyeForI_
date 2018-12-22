require 'nokogiri'
require 'open-uri'

# 서울광역시 대상 주소
url = "http://apis.data.go.kr/B550928/dissForecastInfoSvc/getDissForecastInfo?serviceKey=aAkkQBvnhPvUEXEGqcHEPZYWN8h%2FLqcMChpZFlMdeOtp6jaYY9WdrxfvGAsPNr%2BYrFO0GdlY1GKLVMNKX%2FeHlw%3D%3D&numOfRows=10&pageNo=1&type=xml&dissCd=3&znCd=11"
doc = Nokogiri::XML(open(url))

# totalCount 파싱
item = doc.xpath("//item")
totalCount = item.xpath("//totalCount").inner_text

url = "http://apis.data.go.kr/B550928/dissForecastInfoSvc/getDissForecastInfo?serviceKey=aAkkQBvnhPvUEXEGqcHEPZYWN8h%2FLqcMChpZFlMdeOtp6jaYY9WdrxfvGAsPNr%2BYrFO0GdlY1GKLVMNKX%2FeHlw%3D%3D&numOfRows=" + totalCount + "&pageNo=1&type=xml&dissCd=3&znCd=11"
doc = Nokogiri::XML(open(url))

# puts totalCount

item = doc.xpath("//item")
totalCount = item.xpath("//totalCount").inner_text

cnt = 0

(0..totalCount.to_i-1).each do |i|
    # 서울광역시 종로구 파싱
    if item.xpath("//lowrnkZnCd")[i].inner_text == "11110"
        risk = item.xpath("//risk")[i].inner_text.to_i

        if risk == 1
          risk_text = "관심"
        elsif risk == 2
          risk_text = "주의"
        elsif risk == 3
          risk_text = "경고"
        elsif risk == 4
          risk_text = "위험"
        end
        
        cnt = cnt+1
        
        if cnt == 1
            # 오늘
            @result_1 = risk_text
        elsif cnt == 2
            # 내일
            @result_2 = risk_text
        elsif cnt == 3
            # 모레
            @result_3 = risk_text
        end
    end
end