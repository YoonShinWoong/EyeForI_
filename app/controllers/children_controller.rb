class ChildrenController < ApplicationController
  before_action :authenticate_user! , except: [:intro, :explaination]
  
  # C 만들기 ----------------------------------------
  def new
    # 선생님이 아니면 만들 수 없게
    if current_user.usertype != "teacher"
      redirect_to "/children/index"
    end
  end
  
  def create
    uploader = ImageUploader.new
    uploader.store!(params[:image])

    @child = Child.new
    @child.name =params[:input_name]
    @child.age = params[:input_age].to_i
    @child.gender = params[:input_gender]
    @child.kindergarden_id = current_user.kindergarden_id
    @child.className = params[:input_className]
    @child.classNumber = params[:input_classNumber].to_i
    @child.teacher_id = current_user.id
    @child.image = uploader.url

    @child.save
    redirect_to "/children/index"
  end

  # R 보여주기 ----------------------------------------
  def myChildren
    @children =Child.where("parent_id like ?","#{current_user.id}").order("created_at DESC")
    id = params[:id].to_i
    
    # 내 아이가 없을 경우
    if @children[id].nil?
      redirect_to "/children/search"
    
    # 내 아이 있을 경우
    else
      # id 번 째 아이 
      @child = @children[id]
      cbs = Childbus.where("child_id like ?", @child.id).order("created_at DESC")
      @childbus = cbs
    
    require 'rubygems'
    require 'nokogiri'
    require 'open-uri'
    
    # 서울광역시 대상 주소
    # url = "http://apis.data.go.kr/B550928/dissForecastInfoSvc/getDissForecastInfo?serviceKey=aAkkQBvnhPvUEXEGqcHEPZYWN8h%2FLqcMChpZFlMdeOtp6jaYY9WdrxfvGAsPNr%2BYrFO0GdlY1GKLVMNKX%2FeHlw%3D%3D&numOfRows=10&pageNo=1&type=xml&dissCd=3&znCd=11"
    # doc = Nokogiri::XML(open(url))
    
    # totalCount 파싱
    # item = doc.xpath("//item")
    # totalCount = item.xpath("//totalCount").inner_text
    
    # 서울광역시 totalCount = 25개 구 * 3일 = 75
    totalCount = "75"
    
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
      
      # 2개 이상일 경우
      if cbs.count >= 2
        @childbus = cbs[0..1]
        
      end
      
      # @stcode = @child.id
      agent = Mechanize.new
      # where는 복수형으로 찾아지기 때문에 .first등으로 찾아서 해야함
      # find_by는 제일 처음꺼 하나만 가져온다.
      @kin = Kindergarden.find_by(id: @child.kindergarden.id)
      
      name = @kin.crname
      id = @kin.stcode
      # # name="(신)동화나라 어린이집"        #API에서 받아온 이름을 넣는다.
      # id="41220000258"                    #API에서 받아온 고유번호를 넣는다.
      
      # #  요약 페이지
      page = agent.get("http://info.childcare.go.kr/info/pnis/search/preview/SummaryInfoSlPu.jsp?flag=YJ&STCODE_POP="+id.to_s+"&CRNAMETITLE="+name)        #대입
      search = page.search("td")
      @representative = search[2].text                     #대표자명
      @boss = search[3].text                               #원장명
      @kinder_type = search[4].text                        #설립유형
      @establish_data = search[5].text                     #설립일
      @organization = search[6].text                       #관할 행정기관
      @phone_num = search[7].text                          #전화번호
      @homepage = search[8].text                           #홈페이지 주소
      @time = search[9].text                               #운영시간
      @bus = search[33].text                               #통학차량 운행 여부
      @certification_date = search[34].text                #평가 인증 날짜
      
      # 기본현황 페이지 
      page2 = page.link_with(:text => '기본 현황').click
      search = page2.search("td")
      if search.length == 42
          @noriter = search[7].text                            #놀이터 여부
          @nursery_room_num = search[8].text                   #보육실 개수
          @nursery_room_size = search[9].text                  #보육실 크기
          @build_date = search[17].text                        #건물 건축일
          @floor = search[18].text                             #건물 층수
          @cctv_num = search[25].text                          #cctv 개수
          @cctv_nursery = search[26].text                      #보육실 cctv 개수
          @cctv_play_room = search[27].text                    #공동 놀이실 cctv 개수
          @cctv_noriter = search[28].text                      #놀이터 cctv 개수
          @cctv_cafeteria = search[29].text                    #식당 cctv 개수
          @cctv_auditorium = search[30].text                   #강당 cctv 개수
          @cctv_reserve_time = search[37].text                 #cctv 보유 기간
      #cctv가 없을시
      elsif search.length == 25
          @noriter = search[7].text
          @nursery_room_num = search[8].text
          @nursery_room_size = search[9].text
          @build_date = search[17].text
          @floor = search[18].text
          @cctv_num = search[24].text
      end
      
      page3 = page.link_with(:text => '영유아 및 교직원').click
      search = page3.search("td")
      
      # 어린이 인원 현황
      @max_kid_num = search[0].text                        #정원
      @present_kid_num = search[1].text                    #현원
      @age_0_class_num = search[3].text                    #만 0세 학급수
      @age_0_max_kid_num = search[15].text                 #만 0세 학급 총원
      @age_0_present_kid_num = search[27].text             #만 0세 학급 현원
      
      @age_1_class_num = search[4].text
      @age_1_max_kid_num = search[16].text
      @age_1_present_kid_num = search[28].text
      
      @age_2_class_num = search[5].text
      @age_2_max_kid_num = search[17].text
      @age_2_present_kid_num = search[29].text
      
      @age_3_class_num = search[6].text
      @age_3_max_kid_num = search[18].text
      @age_3_present_kid_num = search[30].text
      
      @age_4_class_num = search[7].text
      @age_4_max_kid_num = search[19].text
      @age_4_present_kid_num = search[31].text
      
      @age_5_class_num = search[8].text
      @age_5_max_kid_num = search[20].text
      @age_5_present_kid_num = search[32].text
      
      # 교직원 현황
      @total_teacher_num = search[38].text                 #총 교사 수
      @nursery_teacher_num = search[40].text               #보육교수 수
      @teach_grade_1 = search[47].text                     #1급 보육교사 자격 교사 수
      @teach_grade_2 = search[48].text
      @teach_grade_3 = search[49].text
      
      # 교직원 근속연수
      @teach_less_than_1 = search[50].text                 #1년 미만
      @teach_less_than_2 = search[51].text                 #1년 이상 2년 미만
      @teach_less_than_4 = search[52].text                 #2년 이상 4년 미만
      @teach_less_than_6 = search[53].text                 #4년 이상 6년 미만
      @teach_more_than_6 = search[54].text                 #6년 이상
      
      page4 = page.link_with(:text => '교육·보육과정').click
      @search = page4.search("td")
      
      # 연간, 월간 교육 과정 파일 다운로드 주소
      search_a = page4.search("a")
      if search_a.length == 12
          search_a = page4.search("#popWrap2 > div > div > div > table:nth-child(4) > tbody > tr > td:nth-child(2) > a")
          @year_nursery_plan_file = search_a.first['href']
      end
      search_a = page4.search("a")
      if search_a.length == 13
          search_a = page4.search("#popWrap2 > div > div > div > table:nth-child(4) > tbody > tr > td.no_right > a")
          @month_nursery_plan_file = search_a.first['href']
      end
      
      # 보육료 현황
      @charge_for_age_0 = search[3].text                   #만 0세 부모 보육료 부담금
      @charge_for_age_1 = search[4].text
      @charge_for_age_2 = search[5].text
      @charge_for_age_3 = search[6].text
      @charge_for_age_4 = search[7].text
      @charge_for_age_5 = search[8].text
      
      page6 = page.link_with(:text => '영양 및 환경 위생').click
      search = page6.search("td")
      search_a = page6.search("a")
      
      #식중독 발생 및 처리 현황
      search_poisoning_tr = page6.search("#popWrap2 > div > div > div > table:nth-child(7) > tbody > tr")
      search_poisoning_td = page6.search("#popWrap2 > div > div > div > table:nth-child(7) > tbody > tr > td")
      @poisoning_row_size = search_poisoning_tr.length
      @poisoning_col_size = search_poisoning_td.length
      @poisoning_td = Array.new(@poisoning_row_size+1) {Array.new(@poisoning_col_size+1)}
      @poisoning_td2 = Array.new(@poisoning_col_size+1)
      (1..@poisoning_row_size).each do |i|
        @poisoning_td2[i] = page6.search("#popWrap2 > div > div > div > table:nth-child(7) > tbody > tr:nth-child(#{i}) > td.no_right").text.gsub("\n","\t")
        (1..@poisoning_col_size).each do |j|
          @poisoning_td[i][j] = page6.search("#popWrap2 > div > div > div > table:nth-child(7) > tbody > tr:nth-child(#{i}) > td:nth-child(#{j})").text.gsub("\n","\t")
        end
      end
      
      #실내 공기질 관리 현황
      search_air_tr = page6.search("#popWrap2 > div > div > div > table:nth-child(9) > tbody > tr")
      search_air_td = page6.search("#popWrap2 > div > div > div > table:nth-child(9) > tbody > tr > td")
      @air_row_size = search_air_tr.length
      @air_col_size = search_air_td.length
      @air_td = Array.new(@air_row_size+1) {Array.new(@air_col_size+1)}
      @air_td2 = Array.new(@air_col_size+1)
      (1..@air_row_size).each do |i|
        @air_td2[i] = page6.search("#popWrap2 > div > div > div > table:nth-child(9) > tbody > tr:nth-child(#{i}) > td.no_right").text.gsub("\n","\t")
        (1..@air_col_size).each do |j|
          @air_td[i][j] = page6.search("#popWrap2 > div > div > div > table:nth-child(9) > tbody > tr:nth-child(#{i}) > td:nth-child(#{j})").text.gsub("\n","\t")
        end
      end
      #popWrap2 > div > div > div > table:nth-child(9) > tbody > tr
      
      # 정기 소독관리 현황
      search_sterilize_tr = page6.search("#popWrap2 > div > div > div > table:nth-child(11) > tbody > tr")
      search_sterilize_td = page6.search("#popWrap2 > div > div > div > table:nth-child(11) > tbody > tr:nth-child(1) > td")
      @sterilize_row_size = search_sterilize_tr.length
      @sterilize_col_size = search_sterilize_td.length
      @sterilize_td = Array.new(@sterilize_row_size+1) {Array.new(@sterilize_col_size+1)}
      @sterilize_td2 = Array.new(@sterilize_col_size+1)
      (1..@sterilize_row_size).each do |i|
        @sterilize_td2[i] = page6.search("#popWrap2 > div > div > div > table:nth-child(11) > tbody > tr:nth-child(#{i}) > td.no_right").text.gsub("\n","\t")
        (1..@sterilize_col_size).each do |j|
          @sterilize_td[i][j] = page6.search("#popWrap2 > div > div > div > table:nth-child(11) > tbody > tr:nth-child(#{i}) > td:nth-child(#{j})").text.gsub("\n","\t")
        end
      end
      
      # 음용수 종류 및 수질 검사 현황
      search_water_tr = page6.search("#popWrap2 > div > div > div > table:nth-child(13) > tbody > tr")
      search_water_td = page6.search("#popWrap2 > div > div > div > table:nth-child(13) > tbody > tr:nth-child(1) > td")
      @water_row_size = search_water_tr.length
      @water_col_size = search_water_td.length
      @water_td = Array.new(@water_row_size+1) {Array.new(@water_col_size+1)}
      @water_td2 = Array.new(@water_col_size+1)
      (1..@water_row_size).each do |i|
        @water_td2[i] = page6.search("#popWrap2 > div > div > div > table:nth-child(13) > tbody > tr:nth-child(#{i}) > td.no_right").text.gsub("\n","\t")
        (1..@water_col_size).each do |j|
          @water_td[i][j] = page6.search("#popWrap2 > div > div > div > table:nth-child(13) > tbody > tr:nth-child(#{i}) > td:nth-child(#{2*j})").text.gsub("\n","\t")
        end
      end
      #popWrap2 > div > div > div > table:nth-child(13) > tbody > tr:nth-child(2) > td:nth-child(2)
      #popWrap2 > div > div > div > table:nth-child(13) > tbody > tr:nth-child(2) > td:nth-child(2)
      #popWrap2 > div > div > div > table:nth-child(13) > tbody > tr:nth-child(2) > td:nth-child(4)
      # @menu_file_text = search_a[11].text                           #식단표 파일 이름
      # @menu_file = "http://info.childcare.go.kr/info/pnis/search/" + page6.link_with(text: @menu_file_text).href[3..-1]   #식단표 다운로드 주소
      # @meal_service_system = search[2].text                         #급식 운영방식
      
      
      page7 = page.link_with(:text => '안전교육·안전점검').click
      search = page7.search("td")
      
      # 최근 3년간 원장 및 보육교사의 보수교육 이수 현황
      @complete_num = search[0].text                           #이수 인원
      @target_num = search[1].text                             #대상 인원
      @firefiting_training = search[3].text                    #소방 대피 훈련 여부
      @firefiting_training_date = search[4].text               #소방 대피 훈련 일자
      
      # 안전 점검 실시 현황
      @gas_inspection = search[5].text                         #가스 점검 여부
      @gas_inspection_date = search[6].text                    #가스 점검 일자
      @fire_safety = search[7].text                            #소방안전 점검 여부
      @fire_safety_date = search[8].text                       #소방안전 점검 일자
      @electricity_inspection = search[9].text                 #전기설비 점검 여부
      @electricity_inspection_date = search[10].text           #전기설비 점검 일자
      
      # 놀이시설 안전검사 현황
      @is_noriter_inspection = search[14].text                 #안전검사 대상 여부
      @noriter_inspection_date = search[15].text               #안전 검사 일자
      @noriter_inspection_result = search[16].text             #안전 검사 결과
    end
    
    
    # 미세먼지 현황 파악
    agent = Mechanize.new
    pageDust = agent.get("https://search.daum.net/search?w=tot&DA=YZR&t__nil_searchbox=btn&sug=&sugo=&q=%EB%AF%B8%EC%84%B8%EB%A8%BC%EC%A7%80")        #대입
    todaydust1 = pageDust.search("#airPollutionNColl > div.coll_cont > div > div.wrap_whole > div.cont_map.bg_map > div.map_region > ul > li.city_01 > a > span > span.txt_state").text.to_i
    
    # 좋음
    if todaydust1>0 && todaydust1<-30 
      @todayDust1 = "좋음"  
    
    # 보통
    elsif todaydust1<=80
      @todayDust1 = "보통"
    
    # 나쁨
    elsif todaydust1<=150
      @todayDust1 = "나쁨"
      
    # 매우 나쁨
    else
      @todayDust1 = "매우나쁨"
    end
  
    # 초미세먼지 현황 파악
    agent = Mechanize.new
    pageDust2 = agent.get("https://search.daum.net/search?nil_suggest=btn&w=tot&DA=SBC&q=%EC%B4%88%EB%AF%B8%EC%84%B8%EB%A8%BC%EC%A7%80")        #대입
    todaydust2 = pageDust2.search("#airPollutionNColl > div.coll_cont > div > div.wrap_whole > div.cont_map.bg_map > div.map_region > ul > li.city_01 > a > span > span.txt_state").text.to_i
    
    # 좋음
    if todaydust2 >0 && todaydust2<=15 
      @todayDust2 = "좋음"  
    
    # 보통
    elsif todaydust2<=35
      @todayDust2 = "보통"
    
    # 나쁨
    elsif todaydust2<=75
      @todayDust2 = "나쁨"
      
    # 매우 나쁨
    else
      @todayDust2 = "매우나쁨"
    end
    
  end
  
  def index
    # 선생님일 경우
    if current_user.usertype == "teacher"
      @children =Child.where("teacher_id like ?","#{current_user.id}").order("created_at DESC").page(params[:page]).per(10)
  
    # 학부모일 경우 못들어옴.
    else
      @children =Child.where("parent_id like ?","#{current_user.id}").order("created_at DESC").page(params[:page]).per(10)
      # redirect_to "/children/show/"
    end
  end

  def show
    @child = Child.find(params[:id])
    cbs = Childbus.where("child_id like ?", @child.id).order("created_at DESC")
    @childbus = cbs
    
    # 2개 이상일 경우
    if cbs.count >= 2
      @childbus = cbs[0..1]
      
    end
    
    # @stcode = @child.id
    agent = Mechanize.new
    # where는 복수형으로 찾아지기 때문에 .first등으로 찾아서 해야함
    # find_by는 제일 처음꺼 하나만 가져온다.
    @kin = Kindergarden.find_by(id: @child.kindergarden.id)
    
    name = @kin.crname
    id = @kin.stcode
    # # name="(신)동화나라 어린이집"        #API에서 받아온 이름을 넣는다.
    # id="41220000258"                    #API에서 받아온 고유번호를 넣는다.
    
    # #  요약 페이지
    page = agent.get("http://info.childcare.go.kr/info/pnis/search/preview/SummaryInfoSlPu.jsp?flag=YJ&STCODE_POP="+id.to_s+"&CRNAMETITLE="+name)        #대입
    search = page.search("td")
    @representative = search[2].text                     #대표자명
    @boss = search[3].text                               #원장명
    @kinder_type = search[4].text                        #설립유형
    @establish_data = search[5].text                     #설립일
    @organization = search[6].text                       #관할 행정기관
    @phone_num = search[7].text                          #전화번호
    @homepage = search[8].text                           #홈페이지 주소
    @time = search[9].text                               #운영시간
    @bus = search[33].text                               #통학차량 운행 여부
    @certification_date = search[34].text                #평가 인증 날짜
    
    # 기본현황 페이지 
    page2 = page.link_with(:text => '기본 현황').click
    search = page2.search("td")
    if search.length == 42
        @noriter = search[7].text                            #놀이터 여부
        @nursery_room_num = search[8].text                   #보육실 개수
        @nursery_room_size = search[9].text                  #보육실 크기
        @build_date = search[17].text                        #건물 건축일
        @floor = search[18].text                             #건물 층수
        @cctv_num = search[25].text                          #cctv 개수
        @cctv_nursery = search[26].text                      #보육실 cctv 개수
        @cctv_play_room = search[27].text                    #공동 놀이실 cctv 개수
        @cctv_noriter = search[28].text                      #놀이터 cctv 개수
        @cctv_cafeteria = search[29].text                    #식당 cctv 개수
        @cctv_auditorium = search[30].text                   #강당 cctv 개수
        @cctv_reserve_time = search[37].text                 #cctv 보유 기간
    #cctv가 없을시
    elsif search.length == 25
        @noriter = search[7].text
        @nursery_room_num = search[8].text
        @nursery_room_size = search[9].text
        @build_date = search[17].text
        @floor = search[18].text
        @cctv_num = search[24].text
    end
    
    page3 = page.link_with(:text => '영유아 및 교직원').click
    search = page3.search("td")
    
    # 어린이 인원 현황
    @max_kid_num = search[0].text                        #정원
    @present_kid_num = search[1].text                    #현원
    @age_0_class_num = search[3].text                    #만 0세 학급수
    @age_0_max_kid_num = search[15].text                 #만 0세 학급 총원
    @age_0_present_kid_num = search[27].text             #만 0세 학급 현원
    
    @age_1_class_num = search[4].text
    @age_1_max_kid_num = search[16].text
    @age_1_present_kid_num = search[28].text
    
    @age_2_class_num = search[5].text
    @age_2_max_kid_num = search[17].text
    @age_2_present_kid_num = search[29].text
    
    @age_3_class_num = search[6].text
    @age_3_max_kid_num = search[18].text
    @age_3_present_kid_num = search[30].text
    
    @age_4_class_num = search[7].text
    @age_4_max_kid_num = search[19].text
    @age_4_present_kid_num = search[31].text
    
    @age_5_class_num = search[8].text
    @age_5_max_kid_num = search[20].text
    @age_5_present_kid_num = search[32].text
    
    # 교직원 현황
    @total_teacher_num = search[38].text                 #총 교사 수
    @nursery_teacher_num = search[40].text               #보육교수 수
    @teach_grade_1 = search[47].text                     #1급 보육교사 자격 교사 수
    @teach_grade_2 = search[48].text
    @teach_grade_3 = search[49].text
    
    # 교직원 근속연수
    @teach_less_than_1 = search[50].text                 #1년 미만
    @teach_less_than_2 = search[51].text                 #1년 이상 2년 미만
    @teach_less_than_4 = search[52].text                 #2년 이상 4년 미만
    @teach_less_than_6 = search[53].text                 #4년 이상 6년 미만
    @teach_more_than_6 = search[54].text                 #6년 이상
    
    page4 = page.link_with(:text => '교육·보육과정').click
    @search = page4.search("td")
    
    # 연간, 월간 교육 과정 파일 다운로드 주소
    search_a = page4.search("a")
    if search_a.length == 12
        search_a = page4.search("#popWrap2 > div > div > div > table:nth-child(4) > tbody > tr > td:nth-child(2) > a")
        @year_nursery_plan_file = search_a.first['href']
    end
    search_a = page4.search("a")
    if search_a.length == 13
        search_a = page4.search("#popWrap2 > div > div > div > table:nth-child(4) > tbody > tr > td.no_right > a")
        @month_nursery_plan_file = search_a.first['href']
    end
    
    # 보육료 현황
    @charge_for_age_0 = search[3].text                   #만 0세 부모 보육료 부담금
    @charge_for_age_1 = search[4].text
    @charge_for_age_2 = search[5].text
    @charge_for_age_3 = search[6].text
    @charge_for_age_4 = search[7].text
    @charge_for_age_5 = search[8].text
    
    page6 = page.link_with(:text => '영양 및 환경 위생').click
    search = page6.search("td")
    search_a = page6.search("a")
    
    #식중독 발생 및 처리 현황
    search_poisoning_tr = page6.search("#popWrap2 > div > div > div > table:nth-child(7) > tbody > tr")
    search_poisoning_td = page6.search("#popWrap2 > div > div > div > table:nth-child(7) > tbody > tr > td")
    @poisoning_row_size = search_poisoning_tr.length
    @poisoning_col_size = search_poisoning_td.length
    @poisoning_td = Array.new(@poisoning_row_size+1) {Array.new(@poisoning_col_size+1)}
    @poisoning_td2 = Array.new(@poisoning_col_size+1)
    (1..@poisoning_row_size).each do |i|
      @poisoning_td2[i] = page6.search("#popWrap2 > div > div > div > table:nth-child(7) > tbody > tr:nth-child(#{i}) > td.no_right").text.gsub("\n","\t")
      (1..@poisoning_col_size).each do |j|
        @poisoning_td[i][j] = page6.search("#popWrap2 > div > div > div > table:nth-child(7) > tbody > tr:nth-child(#{i}) > td:nth-child(#{j})").text.gsub("\n","\t")
      end
    end
    
    #실내 공기질 관리 현황
    search_air_tr = page6.search("#popWrap2 > div > div > div > table:nth-child(9) > tbody > tr")
    search_air_td = page6.search("#popWrap2 > div > div > div > table:nth-child(9) > tbody > tr > td")
    @air_row_size = search_air_tr.length
    @air_col_size = search_air_td.length
    @air_td = Array.new(@air_row_size+1) {Array.new(@air_col_size+1)}
    @air_td2 = Array.new(@air_col_size+1)
    (1..@air_row_size).each do |i|
      @air_td2[i] = page6.search("#popWrap2 > div > div > div > table:nth-child(9) > tbody > tr:nth-child(#{i}) > td.no_right").text.gsub("\n","\t")
      (1..@air_col_size).each do |j|
        @air_td[i][j] = page6.search("#popWrap2 > div > div > div > table:nth-child(9) > tbody > tr:nth-child(#{i}) > td:nth-child(#{j})").text.gsub("\n","\t")
      end
    end
    #popWrap2 > div > div > div > table:nth-child(9) > tbody > tr
    
    # 정기 소독관리 현황
    search_sterilize_tr = page6.search("#popWrap2 > div > div > div > table:nth-child(11) > tbody > tr")
    search_sterilize_td = page6.search("#popWrap2 > div > div > div > table:nth-child(11) > tbody > tr:nth-child(1) > td")
    @sterilize_row_size = search_sterilize_tr.length
    @sterilize_col_size = search_sterilize_td.length
    @sterilize_td = Array.new(@sterilize_row_size+1) {Array.new(@sterilize_col_size+1)}
    @sterilize_td2 = Array.new(@sterilize_col_size+1)
    (1..@sterilize_row_size).each do |i|
      @sterilize_td2[i] = page6.search("#popWrap2 > div > div > div > table:nth-child(11) > tbody > tr:nth-child(#{i}) > td.no_right").text.gsub("\n","\t")
      (1..@sterilize_col_size).each do |j|
        @sterilize_td[i][j] = page6.search("#popWrap2 > div > div > div > table:nth-child(11) > tbody > tr:nth-child(#{i}) > td:nth-child(#{j})").text.gsub("\n","\t")
      end
    end
    
    # 음용수 종류 및 수질 검사 현황
    search_water_tr = page6.search("#popWrap2 > div > div > div > table:nth-child(13) > tbody > tr")
    search_water_td = page6.search("#popWrap2 > div > div > div > table:nth-child(13) > tbody > tr:nth-child(1) > td")
    @water_row_size = search_water_tr.length
    @water_col_size = search_water_td.length
    @water_td = Array.new(@water_row_size+1) {Array.new(@water_col_size+1)}
    @water_td2 = Array.new(@water_col_size+1)
    (1..@water_row_size).each do |i|
      @water_td2[i] = page6.search("#popWrap2 > div > div > div > table:nth-child(13) > tbody > tr:nth-child(#{i}) > td.no_right").text.gsub("\n","\t")
      (1..@water_col_size).each do |j|
        @water_td[i][j] = page6.search("#popWrap2 > div > div > div > table:nth-child(13) > tbody > tr:nth-child(#{i}) > td:nth-child(#{2*j})").text.gsub("\n","\t")
      end
    end
    #popWrap2 > div > div > div > table:nth-child(13) > tbody > tr:nth-child(2) > td:nth-child(2)
    #popWrap2 > div > div > div > table:nth-child(13) > tbody > tr:nth-child(2) > td:nth-child(2)
    #popWrap2 > div > div > div > table:nth-child(13) > tbody > tr:nth-child(2) > td:nth-child(4)
    # @menu_file_text = search_a[11].text                           #식단표 파일 이름
    # @menu_file = "http://info.childcare.go.kr/info/pnis/search/" + page6.link_with(text: @menu_file_text).href[3..-1]   #식단표 다운로드 주소
    # @meal_service_system = search[2].text                         #급식 운영방식
    
    
    page7 = page.link_with(:text => '안전교육·안전점검').click
    search = page7.search("td")
    
    # 최근 3년간 원장 및 보육교사의 보수교육 이수 현황
    @complete_num = search[0].text                           #이수 인원
    @target_num = search[1].text                             #대상 인원
    @firefiting_training = search[3].text                    #소방 대피 훈련 여부
    @firefiting_training_date = search[4].text               #소방 대피 훈련 일자
    
    # 안전 점검 실시 현황
    @gas_inspection = search[5].text                         #가스 점검 여부
    @gas_inspection_date = search[6].text                    #가스 점검 일자
    @fire_safety = search[7].text                            #소방안전 점검 여부
    @fire_safety_date = search[8].text                       #소방안전 점검 일자
    @electricity_inspection = search[9].text                 #전기설비 점검 여부
    @electricity_inspection_date = search[10].text           #전기설비 점검 일자
    
    # 놀이시설 안전검사 현황
    @is_noriter_inspection = search[14].text                 #안전검사 대상 여부
    @noriter_inspection_date = search[15].text               #안전 검사 일자
    @noriter_inspection_result = search[16].text             #안전 검사 결과
    
    
    require 'nokogiri'
    require 'open-uri'
    
    # 서울광역시 대상 주소
    # url = "http://apis.data.go.kr/B550928/dissForecastInfoSvc/getDissForecastInfo?serviceKey=aAkkQBvnhPvUEXEGqcHEPZYWN8h%2FLqcMChpZFlMdeOtp6jaYY9WdrxfvGAsPNr%2BYrFO0GdlY1GKLVMNKX%2FeHlw%3D%3D&numOfRows=10&pageNo=1&type=xml&dissCd=3&znCd=11"
    # doc = Nokogiri::XML(open(url))
    
    # totalCount 파싱
    # item = doc.xpath("//item")
    # totalCount = item.xpath("//totalCount").inner_text
    
    # 서울광역시 totalCount = 25개 구 * 3일 = 75
    totalCount = "75"
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
    # 미세먼지 현황 파악
    agent = Mechanize.new
    pageDust = agent.get("https://search.daum.net/search?w=tot&DA=YZR&t__nil_searchbox=btn&sug=&sugo=&q=%EB%AF%B8%EC%84%B8%EB%A8%BC%EC%A7%80")        #대입
    todaydust1 = pageDust.search("#airPollutionNColl > div.coll_cont > div > div.wrap_whole > div.cont_map.bg_map > div.map_region > ul > li.city_01 > a > span > span.txt_state").text.to_i
    
    # 좋음
    if todaydust1>0 && todaydust1<-30 
      @todayDust1 = "좋음"  
    
    # 보통
    elsif todaydust1<=80
      @todayDust1 = "보통"
    
    # 나쁨
    elsif todaydust1<=150
      @todayDust1 = "나쁨"
      
    # 매우 나쁨
    else
      @todayDust1 = "매우나쁨"
    end
  
    # 초미세먼지 현황 파악
    agent = Mechanize.new
    pageDust2 = agent.get("https://search.daum.net/search?nil_suggest=btn&w=tot&DA=SBC&q=%EC%B4%88%EB%AF%B8%EC%84%B8%EB%A8%BC%EC%A7%80")        #대입
    todaydust2 = pageDust2.search("#airPollutionNColl > div.coll_cont > div > div.wrap_whole > div.cont_map.bg_map > div.map_region > ul > li.city_01 > a > span > span.txt_state").text.to_i
    
    # 좋음
    if todaydust2 >0 && todaydust2<=15 
      @todayDust2 = "좋음"  
    
    # 보통
    elsif todaydust2<=35
      @todayDust2 = "보통"
    
    # 나쁨
    elsif todaydust2<=75
      @todayDust2 = "나쁨"
      
    # 매우 나쁨
    else
      @todayDust2 = "매우나쁨"
    end
    
  end

  # U 수정하기 ----------------------------------------
  def edit
    @child = Child.find(params[:id])
    
    #선생님이 아니면 만들 수 없게
    if @child.teacher_id != current_user.id
      redirect_to :back
    end
    
  end

  def update
    @child = Child.find(params[:id])
    
    @child.name =params[:input_name]
    @child.age = params[:input_age].to_i
    @child.gender = params[:input_gender]
    # @child.kindergarden_id = current_user.kindergarden.id
    @child.className = params[:input_className]
    @child.classNumber = params[:input_classNumber].to_i

    @child.save

    redirect_to "/children/show/#{@child.id}"
  end

  # D 삭제하기 ----------------------------------------
  def destroy
    
    @child = Child.find(params[:id])
    
    #선생님이 아니면 삭제할 수 없게
    if @child.teacher_id != current_user.id
      redirect_to :back
    end
    
    @child.destroy

    redirect_to "/children/index"
  end
  
  # 내 아이 찾기 ---------------------------------------
  def search
    @kindergardens = Kindergarden.where("crname like ?", "%#{params[:input_name]}%").page(params[:page]).per(10)
    
  end
  
  def search_result
    @page = params[:page].to_i # 아이 숫자 카운트용
    @children = Child.where("name like ?", "#{params[:input_name]}").order("created_at DESC").page(params[:page]).per(10)
    @kindergardens = Kindergarden.where("crname like ?", "%#{params[:input_name]}%").page(params[:page]).per(10)
  end
  
  # 승차
  def getin
    # 해당 아이 찾기
    @child = Child.find(params[:id])
    
    tv = Time.now
    
    # 승차
    @child.boarding = "승차"
    @child.save
    
    # 승차 모델 저장
    cb = Childbus.new
    cb.child_id = @child.id
    cb.parent_id = @child.parent_id
    cb.boarding = "승차"
    cb.boardingtime = tv
    cb.save
    
    redirect_to :back
    
  end

  # 하차
  def getout
     # 해당 아이 찾기
    @child = Child.find(params[:id])
    
    tv = Time.now
    
    # 승차했을 경우에만 하차 가능
    if @child.boarding =="승차"
      @child.boarding = "하차"
      @child.save
      
      # 승차 모델 저장
      cb = Childbus.new
      cb.child_id = @child.id
      cb.parent_id = @child.parent_id
      cb.boarding = "하차"
      cb.boardingtime = tv
      cb.save
      
      redirect_to :back
    else
      redirect_to :back
    end
  end
  
  def ajax_show
    @child = Child.find(params[:id])
    @teacher = User.find(@child.teacher_id)
    @kindergarden = Kindergarden.find(@child.kindergarden)
    
    @rev = {
      kindergarden: @kindergarden.crname,
      age: @child.age,
      gender: @child.gender,
      teacher: @teacher.username,
      id: @child.id
    }
    render json: @rev
  end
  
  def getInfo
    agent = Mechanize.new
      # where는 복수형으로 찾아지기 때문에 .first등으로 찾아서 해야함
      # find_by는 제일 처음꺼 하나만 가져온다.
      @kin = Kindergarden.find_by(id: @child.kindergarden.id)
      
      name = @kin.crname
      id = @kin.stcode
      # # name="(신)동화나라 어린이집"        #API에서 받아온 이름을 넣는다.
      # id="41220000258"                    #API에서 받아온 고유번호를 넣는다.
      
      # #  요약 페이지
      page = agent.get("http://info.childcare.go.kr/info/pnis/search/preview/SummaryInfoSlPu.jsp?flag=YJ&STCODE_POP="+id.to_s+"&CRNAMETITLE="+name)        #대입
      search = page.search("td")
      @representative = search[2].text                     #대표자명
      @boss = search[3].text                               #원장명
      @kinder_type = search[4].text                        #설립유형
      @establish_data = search[5].text                     #설립일
      @organization = search[6].text                       #관할 행정기관
      @phone_num = search[7].text                          #전화번호
      @homepage = search[8].text                           #홈페이지 주소
      @time = search[9].text                               #운영시간
      @bus = search[33].text                               #통학차량 운행 여부
      @certification_date = search[34].text                #평가 인증 날짜
      
      # 기본현황 페이지 
      page2 = page.link_with(:text => '기본 현황').click
      search = page2.search("td")
      if search.length == 42
          @noriter = search[7].text                            #놀이터 여부
          @nursery_room_num = search[8].text                   #보육실 개수
          @nursery_room_size = search[9].text                  #보육실 크기
          @build_date = search[17].text                        #건물 건축일
          @floor = search[18].text                             #건물 층수
          @cctv_num = search[25].text                          #cctv 개수
          @cctv_nursery = search[26].text                      #보육실 cctv 개수
          @cctv_play_room = search[27].text                    #공동 놀이실 cctv 개수
          @cctv_noriter = search[28].text                      #놀이터 cctv 개수
          @cctv_cafeteria = search[29].text                    #식당 cctv 개수
          @cctv_auditorium = search[30].text                   #강당 cctv 개수
          @cctv_reserve_time = search[37].text                 #cctv 보유 기간

      
      #cctv가 없을시
      elsif search.length == 25
          @noriter = search[7].text
          @nursery_room_num = search[8].text
          @nursery_room_size = search[9].text
          @build_date = search[17].text
          @floor = search[18].text
          @cctv_num = search[24].text
      end
      
      
      
      
      page3 = page.link_with(:text => '영유아 및 교직원').click
      search = page3.search("td")
      
      # 어린이 인원 현황
      @max_kid_num = search[0].text                        #정원
      @present_kid_num = search[1].text                    #현원
      @age_0_class_num = search[3].text                    #만 0세 학급수
      @age_0_max_kid_num = search[15].text                 #만 0세 학급 총원
      @age_0_present_kid_num = search[27].text             #만 0세 학급 현원
      
      @age_1_class_num = search[4].text
      @age_1_max_kid_num = search[16].text
      @age_1_present_kid_num = search[28].text
      
      @age_2_class_num = search[5].text
      @age_2_max_kid_num = search[17].text
      @age_2_present_kid_num = search[29].text
      
      @age_3_class_num = search[6].text
      @age_3_max_kid_num = search[18].text
      @age_3_present_kid_num = search[30].text
      
      @age_4_class_num = search[7].text
      @age_4_max_kid_num = search[19].text
      @age_4_present_kid_num = search[31].text
      
      @age_5_class_num = search[8].text
      @age_5_max_kid_num = search[20].text
      @age_5_present_kid_num = search[32].text
      
      # 교직원 현황
      @total_teacher_num = search[38].text                 #총 교사 수
      @nursery_teacher_num = search[40].text               #보육교수 수
      @teach_grade_1 = search[47].text                     #1급 보육교사 자격 교사 수
      @teach_grade_2 = search[48].text
      @teach_grade_3 = search[49].text
      
      # 교직원 근속연수
      @teach_less_than_1 = search[50].text                 #1년 미만
      @teach_less_than_2 = search[51].text                 #1년 이상 2년 미만
      @teach_less_than_4 = search[52].text                 #2년 이상 4년 미만
      @teach_less_than_6 = search[53].text                 #4년 이상 6년 미만
      @teach_more_than_6 = search[54].text                 #6년 이상
      
      page4 = page.link_with(:text => '교육·보육과정').click
      @search = page4.search("td")
      
      # 연간, 월간 교육 과정 파일 다운로드 주소
      search_a = page4.search("a")
      if search_a.length == 12
          search_a = page4.search("#popWrap2 > div > div > div > table:nth-child(4) > tbody > tr > td:nth-child(2) > a")
          @year_nursery_plan_file = search_a.first['href']
      end
      search_a = page4.search("a")
      if search_a.length == 13
          search_a = page4.search("#popWrap2 > div > div > div > table:nth-child(4) > tbody > tr > td.no_right > a")
          @month_nursery_plan_file = search_a.first['href']
      end
      
      
      # 보육료 현황
      @charge_for_age_0 = search[3].text                   #만 0세 부모 보육료 부담금
      @charge_for_age_1 = search[4].text
      @charge_for_age_2 = search[5].text
      @charge_for_age_3 = search[6].text
      @charge_for_age_4 = search[7].text
      @charge_for_age_5 = search[8].text
      
      
      page6 = page.link_with(:text => '영양 및 환경 위생').click
      search = page6.search("td")
      search_a = page6.search("a")
      
      #식중독 발생 및 처리 현황
      search_poisoning_tr = page6.search("#popWrap2 > div > div > div > table:nth-child(7) > tbody > tr")
      search_poisoning_td = page6.search("#popWrap2 > div > div > div > table:nth-child(7) > tbody > tr > td")
      @poisoning_row_size = search_poisoning_tr.length
      @poisoning_col_size = search_poisoning_td.length
      @poisoning_td = Array.new(@poisoning_row_size+1) {Array.new(@poisoning_col_size+1)}
      @poisoning_td2 = Array.new(@poisoning_col_size+1)
      (1..@poisoning_row_size).each do |i|
        @poisoning_td2[i] = page6.search("#popWrap2 > div > div > div > table:nth-child(7) > tbody > tr:nth-child(#{i}) > td.no_right").text.gsub("\n","\t")
        (1..@poisoning_col_size).each do |j|
          @poisoning_td[i][j] = page6.search("#popWrap2 > div > div > div > table:nth-child(7) > tbody > tr:nth-child(#{i}) > td:nth-child(#{j})").text.gsub("\n","\t")
        end
      end
      
      #실내 공기질 관리 현황
      search_air_tr = page6.search("#popWrap2 > div > div > div > table:nth-child(9) > tbody > tr")
      search_air_td = page6.search("#popWrap2 > div > div > div > table:nth-child(9) > tbody > tr > td")
      @air_row_size = search_air_tr.length
      @air_col_size = search_air_td.length
      @air_td = Array.new(@air_row_size+1) {Array.new(@air_col_size+1)}
      @air_td2 = Array.new(@air_col_size+1)
      (1..@air_row_size).each do |i|
        @air_td2[i] = page6.search("#popWrap2 > div > div > div > table:nth-child(9) > tbody > tr:nth-child(#{i}) > td.no_right").text.gsub("\n","\t")
        (1..@air_col_size).each do |j|
          @air_td[i][j] = page6.search("#popWrap2 > div > div > div > table:nth-child(9) > tbody > tr:nth-child(#{i}) > td:nth-child(#{j})").text.gsub("\n","\t")
        end
      end
      #popWrap2 > div > div > div > table:nth-child(9) > tbody > tr
      
      # 정기 소독관리 현황
      search_sterilize_tr = page6.search("#popWrap2 > div > div > div > table:nth-child(11) > tbody > tr")
      search_sterilize_td = page6.search("#popWrap2 > div > div > div > table:nth-child(11) > tbody > tr:nth-child(1) > td")
      @sterilize_row_size = search_sterilize_tr.length
      @sterilize_col_size = search_sterilize_td.length
      @sterilize_td = Array.new(@sterilize_row_size+1) {Array.new(@sterilize_col_size+1)}
      @sterilize_td2 = Array.new(@sterilize_col_size+1)
      (1..@sterilize_row_size).each do |i|
        @sterilize_td2[i] = page6.search("#popWrap2 > div > div > div > table:nth-child(11) > tbody > tr:nth-child(#{i}) > td.no_right").text.gsub("\n","\t")
        (1..@sterilize_col_size).each do |j|
          @sterilize_td[i][j] = page6.search("#popWrap2 > div > div > div > table:nth-child(11) > tbody > tr:nth-child(#{i}) > td:nth-child(#{j})").text.gsub("\n","\t")
        end
      end
      
      # 음용수 종류 및 수질 검사 현황
      search_water_tr = page6.search("#popWrap2 > div > div > div > table:nth-child(13) > tbody > tr")
      search_water_td = page6.search("#popWrap2 > div > div > div > table:nth-child(13) > tbody > tr:nth-child(1) > td")
      @water_row_size = search_water_tr.length
      @water_col_size = search_water_td.length
      @water_td = Array.new(@water_row_size+1) {Array.new(@water_col_size+1)}
      @water_td2 = Array.new(@water_col_size+1)
      (1..@water_row_size).each do |i|
        @water_td2[i] = page6.search("#popWrap2 > div > div > div > table:nth-child(13) > tbody > tr:nth-child(#{i}) > td.no_right").text.gsub("\n","\t")
        (1..@water_col_size).each do |j|
          @water_td[i][j] = page6.search("#popWrap2 > div > div > div > table:nth-child(13) > tbody > tr:nth-child(#{i}) > td:nth-child(#{2*j})").text.gsub("\n","\t")
        end
      end
      #popWrap2 > div > div > div > table:nth-child(13) > tbody > tr:nth-child(2) > td:nth-child(2)
      #popWrap2 > div > div > div > table:nth-child(13) > tbody > tr:nth-child(2) > td:nth-child(2)
      #popWrap2 > div > div > div > table:nth-child(13) > tbody > tr:nth-child(2) > td:nth-child(4)
      # @menu_file_text = search_a[11].text                           #식단표 파일 이름
      # @menu_file = "http://info.childcare.go.kr/info/pnis/search/" + page6.link_with(text: @menu_file_text).href[3..-1]   #식단표 다운로드 주소
      # @meal_service_system = search[2].text                         #급식 운영방식
      
      
      page7 = page.link_with(:text => '안전교육·안전점검').click
      search = page7.search("td")
      
      # 최근 3년간 원장 및 보육교사의 보수교육 이수 현황
      @complete_num = search[0].text                           #이수 인원
      @target_num = search[1].text                             #대상 인원
      @firefiting_training = search[3].text                    #소방 대피 훈련 여부
      @firefiting_training_date = search[4].text               #소방 대피 훈련 일자

      # 안전 점검 실시 현황
      @gas_inspection = search[5].text                         #가스 점검 여부
      @gas_inspection_date = search[6].text                    #가스 점검 일자
      @fire_safety = search[7].text                            #소방안전 점검 여부
      @fire_safety_date = search[8].text                       #소방안전 점검 일자
      @electricity_inspection = search[9].text                 #전기설비 점검 여부
      @electricity_inspection_date = search[10].text           #전기설비 점검 일자
      
      # 놀이시설 안전검사 현황
      @is_noriter_inspection = search[14].text                 #안전검사 대상 여부
      @noriter_inspection_date = search[15].text               #안전 검사 일자
      @noriter_inspection_result = search[16].text             #안전 검사 결과
      
      @rev = {
        "name" => @kin.crname,
        "representative" => @representative,
        "boss" => @boss,
        "kinder_type" => @kinder_type,
        "establish_data" => @establish_data,
        "organization" => @organization,
        "phone_num" => @phone_num,
        "homepage" => @homepage,
        "time" => @time,
        "bus" => @bus,
        
        "certification_date" => @certification_date,
        "charge_for_age_0" => @charge_for_age_0,
        "charge_for_age_1" => @charge_for_age_1,
        "charge_for_age_2" => @charge_for_age_2,
        "charge_for_age_3" => @charge_for_age_3,
        "charge_for_age_4" => @charge_for_age_4,
        "charge_for_age_5" => @charge_for_age_5,
        
        "poisoning_row_size" => @poisoning_row_size,
        "poisoning_col_size" =>@poisoning_col_size,
        "poisoning_td" => @poisoning_td,
        "poisoning_td2" => @poisoning_td2,
        
        "sterilize_row_size" => @sterilize_row_size,
        "sterilize_col_size" =>@sterilize_col_size,
        "sterilize_td" => @sterilize_td,
        "sterilize_td2" => @sterilize_td2,
        
        "teach_less_than_1" => @teach_less_than_1,
        "teach_less_than_2" => @teach_less_than_2,
        "teach_less_than_4" => @teach_less_than_4,
        "teach_less_than_6" => @teach_less_than_6,
        "teach_more_than_6" => @teach_more_than_6,
        
        "total_teacher_num" => @total_teacher_num,
        "nursery_teacher_num" => @nursery_teacher_num,
        "teach_grade_1" => @teach_grade_1,
        "teach_grade_2" => @teach_grade_2,
        "teach_grade_3" => @teach_grade_3,
        
        "complete_num" => @complete_num,
        "target_num" => @target_num,
        "firefiting_training" => @firefiting_training,
        "firefiting_training_date" => @firefiting_training_date,
        
        "noriter" => @noriter,
        "nursery_room_num" => @nursery_room_num,
        "nursery_room_size" => @nursery_room_size,
        "establish_data" => @establish_data,
        "floor" => @floor,
        "cctv_num" => @cctv_num,
        "cctv_nursery" => @cctv_nursery,
        "cctv_play_room" => @cctv_play_room,
        "cctv_noriter" => @build_date,
        "cctv_cafeteria" => @cctv_cafeteria,
        "cctv_auditorium" => @cctv_auditorium,
        "ctv_reserve_time" => @ctv_reserve_time,
          
        "noriter" => @noriter,
        "nursery_room_num" => @nursery_room_num,
        "nursery_room_size" => @nursery_room_size,
        "establish_data" => @establish_data,
        "floor" => @floor,
        "cctv_num" => @cctv_num,
          
        "gas_inspection" => @gas_inspection,
        "gas_inspection_date" => @gas_inspection_date ,
        "fire_safety" => @fire_safety  ,
        "fire_safety_date" => @fire_safety_date ,
        "electricity_inspection" => @electricity_inspection,
        "electricity_inspection_date" => @electricity_inspection_date,
        "is_noriter_inspection" => @is_noriter_inspection,
        "noriter_inspection_date" => @noriter_inspection_date,
        "noriter_inspection_result" => @noriter_inspection_result,
        "representative" => @max_kid_num,
        "present_kid_num" => @present_kid_num,
        "age_0_class_num" => @age_0_class_num,
        "age_0_max_kid_num" => @age_0_max_kid_num,
        "age_0_present_kid_num" => @age_0_present_kid_num,
        
        "age_1_class_num" => @age_1_class_num,
        "age_1_max_kid_num" => @age_1_max_kid_num,
        "age_1_present_kid_num" => @age_1_present_kid_num,
        
        "age_2_class_num" => @age_2_class_num,
        "age_2_max_kid_num" => @age_2_max_kid_num,
        "age_2_present_kid_num" => @age_2_present_kid_num,
        
        "age_3_class_num" => @age_3_class_num,
        "age_3_max_kid_num" => @age_3_max_kid_num,
        "age_3_present_kid_num" => @age_3_present_kid_num,
        
        "age_4_class_num" => @age_4_class_num,
        "age_4_max_kid_num" => @age_4_max_kid_num,
        "age_4_present_kid_num" => @age_4_present_kid_num,
        
        "age_5_class_num" => @age_5_class_num,
        "age_5_max_kid_num" => @age_5_max_kid_num,
        "age_5_present_kid_num" => @age_5_present_kid_num
      }
      
      render json: @rev
    end
end
