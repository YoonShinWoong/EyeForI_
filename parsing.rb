require 'nokogiri'
require 'open-uri'
require 'uri'

#한글을 제외한 주소
url1 = "http://api.childcare.go.kr/mediate/rest/cpmsapi020/cpmsapi020/request?key=20f62935a253418bb0ed6c8601934b7d&arname="

#한글
url2 = "서울"

#전체 url
url = URI.encode(url1+url2)

doc = Nokogiri::XML(open(url))

# item = doc.xpath("//item")[0]  # first group parsing

# members = item.xpath("//sidoname")[0]
# puts members.inner_text

# members = item.xpath("//sigunname")[0]
# puts members.inner_text

# members = item.xpath("//arcode")[0]
# puts members.inner_text

#

item = doc.xpath("//item")  # first group parsing

j=0
item.each do |i|
    members = i.xpath("//sidoname")[j]
    puts members.inner_text
    
    members = i.xpath("//sigunname")[j]
    puts members.inner_text
    
    members = i.xpath("//arcode")[j]
    puts members.inner_text

    j = j+1
end

#######################################################

#한글을 제외한 주소
url1 = "http://api.childcare.go.kr/mediate/rest/cpmsapi020/cpmsapi020/request?key=20f62935a253418bb0ed6c8601934b7d&arname="

#한글
url2 = "인천"

#전체 url
url = URI.encode(url1+url2)
doc = Nokogiri::XML(open(url))

item = doc.xpath("//item")  # first group parsing

j=0
item.each do |i|
    members = i.xpath("//sidoname")[j]
    puts members.inner_text
    
    members = i.xpath("//sigunname")[j]
    puts members.inner_text
    
    members = i.xpath("//arcode")[j]
    puts members.inner_text

    j = j+1
end

#######################################################

#한글을 제외한 주소
url1 = "http://api.childcare.go.kr/mediate/rest/cpmsapi020/cpmsapi020/request?key=20f62935a253418bb0ed6c8601934b7d&arname="

#한글
url2 = "경기도"

#전체 url
url = URI.encode(url1+url2)
doc = Nokogiri::XML(open(url))

item = doc.xpath("//item")  # first group parsing

j=0
item.each do |i|
    members = i.xpath("//sidoname")[j]
    puts members.inner_text
    
    members = i.xpath("//sigunname")[j]
    puts members.inner_text
    
    members = i.xpath("//arcode")[j]
    puts members.inner_text

    j = j+1
end

#######################################################

#한글을 제외한 주소
url1 = "http://api.childcare.go.kr/mediate/rest/cpmsapi020/cpmsapi020/request?key=20f62935a253418bb0ed6c8601934b7d&arname="

#한글
url2 = "강원도"

#전체 url
url = URI.encode(url1+url2)
doc = Nokogiri::XML(open(url))

item = doc.xpath("//item")  # first group parsing

j=0
item.each do |i|
    members = i.xpath("//sidoname")[j]
    puts members.inner_text
    
    members = i.xpath("//sigunname")[j]
    puts members.inner_text
    
    members = i.xpath("//arcode")[j]
    puts members.inner_text

    j = j+1
end

#######################################################

#한글을 제외한 주소
url1 = "http://api.childcare.go.kr/mediate/rest/cpmsapi020/cpmsapi020/request?key=20f62935a253418bb0ed6c8601934b7d&arname="

#한글
url2 = "충청남도"

#전체 url
url = URI.encode(url1+url2)
doc = Nokogiri::XML(open(url))

item = doc.xpath("//item")  # first group parsing

j=0
item.each do |i|
    members = i.xpath("//sidoname")[j]
    puts members.inner_text
    
    members = i.xpath("//sigunname")[j]
    puts members.inner_text
    
    members = i.xpath("//arcode")[j]
    puts members.inner_text

    j = j+1
end

#######################################################

#한글을 제외한 주소
url1 = "http://api.childcare.go.kr/mediate/rest/cpmsapi020/cpmsapi020/request?key=20f62935a253418bb0ed6c8601934b7d&arname="

#한글
url2 = "충청북도"

#전체 url
url = URI.encode(url1+url2)
doc = Nokogiri::XML(open(url))

item = doc.xpath("//item")  # first group parsing

j=0
item.each do |i|
    members = i.xpath("//sidoname")[j]
    puts members.inner_text
    
    members = i.xpath("//sigunname")[j]
    puts members.inner_text
    
    members = i.xpath("//arcode")[j]
    puts members.inner_text

    j = j+1
end

#######################################################

#한글을 제외한 주소
url1 = "http://api.childcare.go.kr/mediate/rest/cpmsapi020/cpmsapi020/request?key=20f62935a253418bb0ed6c8601934b7d&arname="

#한글
url2 = "대전"

#전체 url
url = URI.encode(url1+url2)
doc = Nokogiri::XML(open(url))

item = doc.xpath("//item")  # first group parsing

j=0
item.each do |i|
    members = i.xpath("//sidoname")[j]
    puts members.inner_text
    
    members = i.xpath("//sigunname")[j]
    puts members.inner_text
    
    members = i.xpath("//arcode")[j]
    puts members.inner_text

    j = j+1
end

#######################################################

#한글을 제외한 주소
url1 = "http://api.childcare.go.kr/mediate/rest/cpmsapi020/cpmsapi020/request?key=20f62935a253418bb0ed6c8601934b7d&arname="

#한글
url2 = "세종"

#전체 url
url = URI.encode(url1+url2)
doc = Nokogiri::XML(open(url))

item = doc.xpath("//item")  # first group parsing

j=0
item.each do |i|
    members = i.xpath("//sidoname")[j]
    puts members.inner_text
    
    members = i.xpath("//sigunname")[j]
    puts members.inner_text
    
    members = i.xpath("//arcode")[j]
    puts members.inner_text

    j = j+1
end

#######################################################

#한글을 제외한 주소
url1 = "http://api.childcare.go.kr/mediate/rest/cpmsapi020/cpmsapi020/request?key=20f62935a253418bb0ed6c8601934b7d&arname="

#한글
url2 = "경상북도"

#전체 url
url = URI.encode(url1+url2)
doc = Nokogiri::XML(open(url))

item = doc.xpath("//item")  # first group parsing

j=0
item.each do |i|
    members = i.xpath("//sidoname")[j]
    puts members.inner_text
    
    members = i.xpath("//sigunname")[j]
    puts members.inner_text
    
    members = i.xpath("//arcode")[j]
    puts members.inner_text

    j = j+1
end

#######################################################

#한글을 제외한 주소
url1 = "http://api.childcare.go.kr/mediate/rest/cpmsapi020/cpmsapi020/request?key=20f62935a253418bb0ed6c8601934b7d&arname="

#한글
url2 = "대구"

#전체 url
url = URI.encode(url1+url2)
doc = Nokogiri::XML(open(url))

item = doc.xpath("//item")  # first group parsing

j=0
item.each do |i|
    members = i.xpath("//sidoname")[j]
    puts members.inner_text
    
    members = i.xpath("//sigunname")[j]
    puts members.inner_text
    
    members = i.xpath("//arcode")[j]
    puts members.inner_text

    j = j+1
end

#######################################################

#한글을 제외한 주소
url1 = "http://api.childcare.go.kr/mediate/rest/cpmsapi020/cpmsapi020/request?key=20f62935a253418bb0ed6c8601934b7d&arname="

#한글
url2 = "울산"

#전체 url
url = URI.encode(url1+url2)
doc = Nokogiri::XML(open(url))

item = doc.xpath("//item")  # first group parsing

j=0
item.each do |i|
    members = i.xpath("//sidoname")[j]
    puts members.inner_text
    
    members = i.xpath("//sigunname")[j]
    puts members.inner_text
    
    members = i.xpath("//arcode")[j]
    puts members.inner_text

    j = j+1
end

#######################################################

#한글을 제외한 주소
url1 = "http://api.childcare.go.kr/mediate/rest/cpmsapi020/cpmsapi020/request?key=20f62935a253418bb0ed6c8601934b7d&arname="

#한글
url2 = "경상남도"

#전체 url
url = URI.encode(url1+url2)
doc = Nokogiri::XML(open(url))

item = doc.xpath("//item")  # first group parsing

j=0
item.each do |i|
    members = i.xpath("//sidoname")[j]
    puts members.inner_text
    
    members = i.xpath("//sigunname")[j]
    puts members.inner_text
    
    members = i.xpath("//arcode")[j]
    puts members.inner_text

    j = j+1
end

#######################################################

#한글을 제외한 주소
url1 = "http://api.childcare.go.kr/mediate/rest/cpmsapi020/cpmsapi020/request?key=20f62935a253418bb0ed6c8601934b7d&arname="

#한글
url2 = "부산"

#전체 url
url = URI.encode(url1+url2)
doc = Nokogiri::XML(open(url))

item = doc.xpath("//item")  # first group parsing

j=0
item.each do |i|
    members = i.xpath("//sidoname")[j]
    puts members.inner_text
    
    members = i.xpath("//sigunname")[j]
    puts members.inner_text
    
    members = i.xpath("//arcode")[j]
    puts members.inner_text

    j = j+1
end

#######################################################

#한글을 제외한 주소
url1 = "http://api.childcare.go.kr/mediate/rest/cpmsapi020/cpmsapi020/request?key=20f62935a253418bb0ed6c8601934b7d&arname="

#한글
url2 = "전라북도"

#전체 url
url = URI.encode(url1+url2)
doc = Nokogiri::XML(open(url))

item = doc.xpath("//item")  # first group parsing

j=0
item.each do |i|
    members = i.xpath("//sidoname")[j]
    puts members.inner_text
    
    members = i.xpath("//sigunname")[j]
    puts members.inner_text
    
    members = i.xpath("//arcode")[j]
    puts members.inner_text

    j = j+1
end

#######################################################

#한글을 제외한 주소
url1 = "http://api.childcare.go.kr/mediate/rest/cpmsapi020/cpmsapi020/request?key=20f62935a253418bb0ed6c8601934b7d&arname="

#한글
url2 = "광주"

#전체 url
url = URI.encode(url1+url2)
doc = Nokogiri::XML(open(url))

item = doc.xpath("//item")  # first group parsing

j=0
item.each do |i|
    members = i.xpath("//sidoname")[j]
    puts members.inner_text
    
    members = i.xpath("//sigunname")[j]
    puts members.inner_text
    
    members = i.xpath("//arcode")[j]
    puts members.inner_text

    j = j+1
end

#######################################################

#한글을 제외한 주소
url1 = "http://api.childcare.go.kr/mediate/rest/cpmsapi020/cpmsapi020/request?key=20f62935a253418bb0ed6c8601934b7d&arname="

#한글
url2 = "전라남도"

#전체 url
url = URI.encode(url1+url2)
doc = Nokogiri::XML(open(url))

item = doc.xpath("//item")  # first group parsing

j=0
item.each do |i|
    members = i.xpath("//sidoname")[j]
    puts members.inner_text
    
    members = i.xpath("//sigunname")[j]
    puts members.inner_text
    
    members = i.xpath("//arcode")[j]
    puts members.inner_text

    j = j+1
end

#######################################################

#한글을 제외한 주소
url1 = "http://api.childcare.go.kr/mediate/rest/cpmsapi020/cpmsapi020/request?key=20f62935a253418bb0ed6c8601934b7d&arname="

#한글
url2 = "제주"

#전체 url
url = URI.encode(url1+url2)
doc = Nokogiri::XML(open(url))

item = doc.xpath("//item")  # first group parsing

j=0
item.each do |i|
    members = i.xpath("//sidoname")[j]
    puts members.inner_text
    
    members = i.xpath("//sigunname")[j]
    puts members.inner_text
    
    members = i.xpath("//arcode")[j]
    puts members.inner_text

    j = j+1
end

#######################################################
