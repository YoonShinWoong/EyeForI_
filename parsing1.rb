require 'nokogiri'
require 'open-uri'

arcode = "42820"
doc = Nokogiri::XML(open("http://api.childcare.go.kr/mediate/rest/cpmsapi030/cpmsapi030/request?key=08b5b6f754264e40bd3018ca28921360&arcode=" + arcode + "&stcode="))

# item = doc.xpath("//item")[0]  # first group parsing
# members = item.xpath("//sidoname")[0]
# puts members.inner_text

# members = item.xpath("//sigunname")[0]
# puts members.inner_text

# members = item.xpath("//stcode")[0]
# puts members.inner_text

# item 파싱
item = doc.xpath("//item")

counter = 0
# item 내부 정보 하나씩 꺼내기
item.each do |i|

  members = i.xpath("//sidoname")[counter]
  puts members.inner_text
  
  members = i.xpath("//sigunname")[counter]
  puts members.inner_text
  
  members = i.xpath("//stcode")[counter]
  puts members.inner_text
  
  members = i.xpath("//crname")[counter]
  puts members.inner_text
  
  members = i.xpath("//crtypename")[counter]
  puts members.inner_text
  
  members = i.xpath("//crstatusname")[counter]
  puts members.inner_text
  
  members = i.xpath("//zipcode")[counter]
  puts members.inner_text
  
  members = i.xpath("//craddr")[counter]
  puts members.inner_text
  
  members = i.xpath("//crtelno")[counter]
  puts members.inner_text
  
  members = i.xpath("//crfaxno")[counter]
  puts members.inner_text
  
  members = i.xpath("//crhome")[counter]
  puts members.inner_text
  
  members = i.xpath("//nrtrroomcnt")[counter]
  puts members.inner_text
  
  members = i.xpath("//nrtrroomsize")[counter]
  puts members.inner_text
  
  members = i.xpath("//plgrdco")[counter]
  puts members.inner_text
  
  members = i.xpath("//chcrtescnt")[counter]
  puts members.inner_text
  
  members = i.xpath("//crcapat")[counter]
  puts members.inner_text
  
  members = i.xpath("//crchcnt")[counter]
  puts members.inner_text
  
  members = i.xpath("//la")[counter]
  puts members.inner_text
  
  members = i.xpath("//lo")[counter]
  puts members.inner_text
  
  members = i.xpath("//crcargbname")[counter]
  puts members.inner_text
  
  members = i.xpath("//crcnfmdt")[counter]
  puts members.inner_text
  
  members = i.xpath("//crpausebegindt")[counter]
  puts members.inner_text
  
  members = i.xpath("//crpauseenddt")[counter]
  puts members.inner_text
  
  members = i.xpath("//crabldt")[counter]
  puts members.inner_text
  
  members = i.xpath("//crspec")[counter]
  puts members.inner_text
  
  counter += 1
end



# 0.upto(9) do |c|
#     members = item.xpath("//crhome")[c]
#     puts members.inner_text
# end