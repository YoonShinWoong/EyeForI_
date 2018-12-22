require 'mechanize'
require 'open-uri'

class CrawlingController < ApplicationController
  def crawling_view
    agent = Mechanize.new
    # where는 복수형으로 찾아지기 때문에 .first등으로 찾아서 해얗마
    # find_by는 제일 처음꺼 하나만 가져온다.
    @kin = Kindergarden.find_by(id: 21449)
    name = @kin.crname
    id = @kin.stcode
    # name="(신)동화나라 어린이집"        #API에서 받아온 이름을 넣는다.
    # id="41220000258"                    #API에서 받아온 고유번호를 넣는다.
    
    #  요약 페이지
    page = agent.get("http://info.childcare.go.kr/info/pnis/search/preview/SummaryInfoSlPu.jsp?flag=YJ&STCODE_POP="+id+"&CRNAMETITLE="+name)        #대입
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
    
    # page5 = page.link_with(:text => '예·결산 등 회계').click
    # search = page5.search("td")
    
    
    page6 = page.link_with(:text => '영양 및 환경 위생').click
    search = page6.search("td")
    search_a = page6.search("a")
    @menu_file = search_a[10]['href']
    @meal_service_system = search[2].text
    
    if search.length == 20
        # 식중독 발생 및 처리 현황
        @food_poisoning = {
            date: nil,                               #발생일시
            total_kid_num: nil,                      #전체 아동수
            poisoned_kid_num: nil,                   #발생 아동수
            content: nil                             #처리내용
        }
        # 실내 공기질 관리 현황
        @indoor_air_quality_management = {
            is_target: search[11].text,              #의무 대상 시설 여부
            date: search[12].text,                   #점검 일자
            result: search[13].text                  #점검 결과
        }
        # 정기 소독 관리 현황
        @sterilize_management ={
            is_target: search[14].text,              #의무 대상 시설 여부
            date: search[15].text,                   #점검 일자
            result: search[16].text                  #점검 결과
        }
        # 음용수 종류 및 수질 검사 현황
        @water_quality = {
            type: search[17].text,                                      #사용 음용수
            underground_water_inspection: search[18].text,              #지하수 사용 시 수질검사 여부
            underground_water_inspection_data: search[19].text,         #검사 일자
            underground_water_inspection_result: search[20].text        #검사 결과
        }
    elsif search.length == 23
        @food_poisoning = {
            date: search[10].text,
            total_kid_num: search[11].text,
            poisoned_kid_num: search[12].text,
            content: search[13].text
        }
        @indoor_air_quality_management = {
            is_target: search[14].text,
            date: search[15].text,
            result: search[16].text
        }
        @sterilize_management ={
            is_target: search[17].text,
            date: search[18].text,
            result: search[19].text
        }
        @water_quality = {
            type: search[20].text,
            underground_water_inspection: search[21].text,
            underground_water_inspection_data: search[22].text,
            underground_water_inspection_result: search[23].text
        }
    end
    
    
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
end
