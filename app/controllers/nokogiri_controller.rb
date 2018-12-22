class NokogiriController < ApplicationController
  require 'nokogiri'
  require 'open-uri'
  require 'uri'
  
  def region
    sido = 0
    
    begin
    # 한글을 제외한 주소
    url1 = "http://api.childcare.go.kr/mediate/rest/cpmsapi020/cpmsapi020/request?key=20f62935a253418bb0ed6c8601934b7d&arname="
    
    # 주소에 들어갈 시도의 이름
    if(sido==0)
      url2 = "서울"
    elsif(sido==1)
      url2 = "인천"
    elsif(sido==2)
      url2 = "경기도"
    elsif(sido==3)
      url2 = "강원도"
    elsif(sido==4)
      url2 = "충청남도"
    elsif(sido==5)
      url2 = "충청북도"
    elsif(sido==6)
      url2 = "대전"
    elsif(sido==7)
      url2 = "세종"
    elsif(sido==8)
      url2 = "경상북도"
    elsif(sido==9)
      url2 = "대구"
    elsif(sido==10)
      url2 = "울산"
    elsif(sido==11)
      url2 = "경상남도"
    elsif(sido==12)
      url2 = "부산"
    elsif(sido==13)
      url2 = "전라북도"
    elsif(sido==14)
      url2 = "광주"
    elsif(sido==15)
      url2 = "전라남도"
    elsif(sido==16)
      url2 = "제주"
    end
    
    # 전체 url
    url = URI.encode(url1+url2)
    doc = Nokogiri::XML(open(url))
  
    # item 파싱
    item = doc.xpath("//item")
    
    counter = 0
    
    # item 내부 정보 하나씩 꺼내기
    item.each do |i|
      @region = Region.new
      
      members = i.xpath("//sidoname")[counter]
      @region.sidoname = members.inner_text
      
      members = i.xpath("//sigunname")[counter]
      @region.sigunname = members.inner_text
      
      members = i.xpath("//arcode")[counter]
      @region.arcode = members.inner_text
      
      @region.save
      counter += 1
    end
    
    sido +=1
    end while sido <=16

  end
  
  def frequent
    require 'rubygems'
    require 'json'
    require 'pp'
    
    # 서울광역시 전체 선택
    url = "http://apis.data.go.kr/B552061/frequentzoneChild/getRestFrequentzoneChild?servicekey=aAkkQBvnhPvUEXEGqcHEPZYWN8h%2FLqcMChpZFlMdeOtp6jaYY9WdrxfvGAsPNr%2BYrFO0GdlY1GKLVMNKX%2FeHlw%3D%3D&searchYearCd=2017027&siDo=11&guGun="
    
    doc = JSON.parse(open(url).read)
    # pp doc
    
    # TotalCount 11
    result = doc['searchResult']['frequentzone']
    
    (0..10).each do |i|
      @frequent = Frequent.new
      
      @frequent.spotname =  result[i]['spotname']
      # 위도 경도
      @frequent.x_crd = result[i]['x_crd']
      @frequent.y_crd =  result[i]['y_crd']
      
      @frequent.save
    end
  end
  
  def school
    require 'rubygems'
    require 'pp'
    require 'simple_xlsx_reader'
    
    # Excel 파일 읽기
    workbook = SimpleXlsxReader.open './seoul_schoolZone.xlsx'
    
    # sheet 읽기
    worksheets = workbook.sheets
    
    # 반복문
    worksheets.each do |worksheet|
      worksheet.rows.each do |row|
        # 새 data 만들기
        @schoolZone = SchoolZone.new
    
        row_cells = row
        @schoolZone.spotname = row_cells[1] # spotname
        @schoolZone.x_crd = row_cells[5].to_f # x_crd
        @schoolZone.y_crd = row_cells[4].to_f # y_crd
        @schoolZone.save
      end
    end
  end
  
  def initialize_x_y
    for i in 1..21
      @pub = Danger.find(i)
      puts "@@@@@@@@@@@@@@@@@@@@@#{@pub.name}@@@@@@@@@@@@@@@"
      @pub.x = nil
      @pub.y = nil
      @pub.save
    end
  end
  
  def position
   
  end
  
  def get_position
     @pub = Danger.all
    
    @rev = {
      pub: @pub
    }
    
    render json: @rev
  end
  
  def save_position
    x_s = params[:x_s]
    y_s = params[:y_s]
    
    puts "#{x_s.class}"
    pub = Danger.all
    i = 0
    pub.each do |p|
      p.x = x_s[i].to_f
      p.y = y_s[i].to_f
      # puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@#{p.x} #{p.y}@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
      p.save
      i += 1
    end
    @rev = {}
    render json: @rev
  end
  
  def distance
    require 'geokit'
    
    kinds = Kindergarden.all
    pub = Danger.all
    acci = Frequent.all
    sz = SchoolZone.all
    
    
    kinds.each do |k|
      if k.la != nil
        
        cnt = 0
        dis = 0
        current_location = Geokit::LatLng.new(k.la, k.lo)
        
        pub.each do |p|
          destination = "#{p.x},#{p.y}"
          dis = current_location.distance_to(destination)
          if dis < 1.86411
            cnt += 1
            k.dan.push(p.id.to_s)
            # puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#{p.name}:#{dis}@@@@@@@@@@@@@@@@@@@@@@"
          end
        end
        
        acci.each do |a|
          destination = "#{a.y_crd},#{a.x_crd}"
          dis = current_location.distance_to(destination)
          if dis < 1.86411
            cnt += 50
            k.fre.push(a.id.to_s)
            # puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#{a.spotname}:#{dis}@@@@@@@@@@@@@@@@@@@@@@"
          end
        end
        
        sz.each do |s|
          destination = "#{s.y_crd},#{s.x_crd}"
          dis = current_location.distance_to(destination)
          if dis < 1.86411
            cnt -= 1
            k.sch.push(s.id.to_s)
            # puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#{s.spotname}:#{dis}@@@@@@@@@@@@@@@@@@@@@@" 
          end
        end
        
        if cnt < -10
          k.safetyGrade = 'S'
        elsif cnt < 25
          k.safetyGrade = 'A'
        elsif cnt < 60
          k.safetyGrade = 'B'
        elsif cnt < 120
          k.safetyGrade = 'C'
        elsif cnt < 180
          k.safetyGrade = 'D'
        else
          k.safetyGrade = 'F'
        end
        
        
        k.save
        # puts "@@@@@@@@@@@@@@@@@@@@@@@@#{k.crname}: #{cnt}@@@@@@@@@@@@@@@@"
      end
    end
    @kind = Kindergarden.all
  end
  
  def danger2
    require 'roo'
    # Danger.all.each do |d|
    #   d.destroy
    # end
    
    # 서울광역시 엑셀 데이터
    xlsx = Roo::Excelx.new("./seoul.xlsx")
    # 전체 데이터 2 ~ 2083 중 일부만 시드생성
    # 2~2083
    (2..2083).each do |i|
        @danger = Danger.new
        
        @danger.controlnumber = xlsx.cell(i, 'A')
        @danger.phone = xlsx.cell(i, 'B')
        address = xlsx.cell(i, 'C')
        @danger.zipcode = xlsx.cell(i, 'D')
        @danger.name = xlsx.cell(i, 'E')
        @danger.category = xlsx.cell(i, 'F')
        
        # 주소값이 비어있지 않으면 () 처리 후 저장하기
        if !(address.nil?)
          # () 버리기
          strStart = address.index('(')
          
          # 비어있지 않으면 저장한다
          if !(address.empty?)
              @danger.address = address[0..(strStart-1)]
              @danger.save
          end
        end
        
        # res = Naver::Map.geocode(query: @danger.address)
        # 좌표정보 X와 Y는 위도와 경도가 아니라
        # 중부원점TM(EPSG:2097) 좌표계에 따른 해당위치의 좌표정보이다.
        # @danger.x = res.x
        # @danger.y = res.y
    end
  end
end
