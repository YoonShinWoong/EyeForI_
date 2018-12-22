class KakaosController < ApplicationController
  
  def keyboard
    @user_key = params[:user_key]
    @kakao = Kakao.find_by_user_key(@user_key)
    
    if @kakao.nil?
     @msg = {type: "buttons",
            buttons: ["로그인", "로그인 없이 시작"]}
            render json: @msg, status: :ok
    
    else
      @msg = {type: "buttons",
            buttons: ["어린이집 정보탐색", "내 아이 정보탐색", "그만하기"]}
            render json: @msg, status: :ok
    end
    
  end

  def message
    
    require 'nokogiri'
    require 'open-uri'
    require 'mechanize'
    
    @result = params[:content]
    @user_key = params[:user_key]
    @kakao = Kakao.find_by_user_key(@user_key) #현재 유저키로 카카오 Model 정보 가져오기
    
    # 로그인 ----------------------------------------------------------------------------------시작
    if @result == "로그인"
      # 현재 아이디로 로그인 정보가 없다면
        if @kakao.nil?
         @msg = {
          message: {text: "아이포아이 Email을 입력해주세요!\n예)eyefori@naver.com"},
          keyboard: { type: "text",
                    }
                }
                render json: @msg, status: :ok
                @kakao = Kakao.create(user_key: @user_key)
                @kakao.lastQuestion = "email"  #질문 컬럼넣기
                @kakao.save
      
        # 현재 로그인 되어있다면
        elsif @kakao.login == true
         #유저 정보를 찾기
          @user = User.find_by_email(@kakao.email)
            @msg = {
                message: {text: "로그인 성공!\n#{@user.username}님 반갑습니다!\n원하시는 기능을 선택해주세요!"},
                keyboard: {type: "buttons",
                         buttons: ["어린이집 정보탐색", "내 아이 정보탐색", "그만하기"]
                        }
                   }
                render json: @msg, status: :ok
            
        
        # 현재 아이디로 로그인 정보가 있다면                
        elsif @kakao.login == false
           @msg = {
            message: {text: "로그인 이력이 있습니다.\n#{@kakao.email}의 아이디로 로그인 하시겠습니까?"},
            keyboard: { type: "buttons",
                        buttons: ["확인", "아니오(새로운 로그인하기)"]
                      }
                  }
                  render json: @msg, status: :ok
                  @kakao.lastQuestion = "기존 로그인" #질문 컬럼넣기
                  @kakao.save
        end
      
    # 기존 로그인 처리
    elsif @kakao != nil && @kakao.lastQuestion == "기존 로그인"

      @user = User.find_by_email(@kakao.email)
      # 확인
      if @result == "확인"
        @msg = {
              message: {text: "로그인 성공!\n#{@user.username}님 반갑습니다!\n원하시는 기능을 선택해주세요!"},
              keyboard: {type: "buttons",
                       buttons: ["어린이집 정보탐색", "내 아이 정보탐색", "그만하기"]
                      }
                 }
              render json: @msg, status: :ok
        @kakao.login = true
        @kakao.lastQuestion =""
        @kakao.save
        
      # 아니오(새로운 로그인하기)
      else
        @msg = {
          message: {text: "아이포아이 Email을 입력해주세요!\n예)eyefori@naver.com"},
          keyboard: { type: "text",
                    }
                }
                render json: @msg, status: :ok
                @kakao.lastQuestion = "email" #질문 컬럼넣기
                @kakao.save
      
      end
      
    # 새로운 로그인-------------------
    elsif @result.include? "새로운 로그인하기"
      @msg = {
          message: {text: "아이포아이 Email을 입력해주세요!\n예)eyefori@naver.com"},
          keyboard: { type: "text",
                    }
                }
                render json: @msg, status: :ok
                @kakao.lastQuestion = "email" #질문 컬럼넣기
                @kakao.save
    
    # 비밀번호 입력
    elsif @kakao != nil && @kakao.lastQuestion == "email"
      # 이메일 정보 저장 
        @kakao.email = params[:content]
        @msg = {
          message: {text: "#{@kakao.email}계정 비밀번호를 입력해주세요!\n예)eyefori123"},
          keyboard: { type: "text",
                    }
                }
                render json: @msg, status: :ok
                @kakao.lastQuestion = "password" #질문 컬럼넣기
                @kakao.save
    
    elsif @kakao != nil && @kakao.lastQuestion == "password" 
        
        #유저 정보를 찾고 로그인 완료
        @user = User.find_by_email(@kakao.email)
        
        # 유저 정보가 없을 경우
        if @user.nil?
          @msg = {
          message: {text: "로그인 실패! 처음부터 다시 로그인해주세요!"},
          keyboard: {type: "buttons",
                   buttons: ["로그인", "로그인 없이 시작", "그만하기"]
                  }
             }
          render json: @msg, status: :ok
          @kakao.password = params[:content]
          @kakao.destroy
        
        elsif @user.valid_password?(params[:content])
          @msg = {
          message: {text: "로그인 성공!\n#{@user.username}님 반갑습니다!\n원하시는 기능을 선택해주세요!"},
          keyboard: {type: "buttons",
                   buttons: ["어린이집 정보탐색", "내 아이 정보탐색", "그만하기"]
                  }
             }
          render json: @msg, status: :ok
          @kakao.lastQuestion = ""
          @kakao.password = params[:content]
          @kakao.login =true
          @kakao.save
          
        # 로그인 실패시
        else
          @msg = {
          message: {text: "로그인 실패! 처음부터 다시 로그인해주세요!"},
          keyboard: {type: "buttons",
                   buttons: ["로그인", "로그인 없이 시작", "그만하기"]
                  }
             }
          render json: @msg, status: :ok
          @kakao.password = params[:content]
          @kakao.destroy
        end
    
    # 로그아웃하기
    elsif @result.include? "로그아웃"
      @msg = {
          message: {text: "로그아웃 하였습니다!"},
          keyboard: {type: "buttons",
                   buttons: ["로그인", "로그인 없이 시작", "그만하기"]
                  }
             }
                render json: @msg, status: :ok
                @kakao.login = false
                @kakao.save
    # 새로운 로그인-------------------끝
    
    # 로그인 없이 시작
    elsif @result.include? "로그인 없이 시작"
      @msg ={ 
        message: {text: "원하시는 기능을 선택해주세요."},            
        keyboard: {type: "buttons",
                   buttons: ["어린이집 정보탐색", "그만하기"]
                  }
             } 
          render json: @msg, status: :ok
        
    elsif @result == "내 정보"
      @user = User.find_by_email(@kakao.email)
      @msg ={ 
        message: {text: "이메일 : #{@user.email}\n이름 : #{@user.username}\n성별 : #{@user.gender}\n나이 : #{@user.age}\n전화번호 : #{@user.telephone}"},            
        keyboard: {type: "text",
                  # buttons: ["기능 시작", "텍스트로 검색", "그만하기"]
                  }
             } 
          render json: @msg, status: :ok
    
    # 로그인 ---------------------------------------------------------------------------------- 끝
    
    # 기능 1 ---------------------------------------------------------------------------시작
    elsif @result == "어린이집 정보탐색"
      @msg = {
        message: {text: "어린이집 정보탐색 서비스는 아이포아이 웹으로 이용해주세요.",
                  message_button: { "label": "아이포아이 바로가기", "url": "https://eyefori-woongsin94.c9users.io/kindergardens/search"}
        },
        
        keyboard: { type: "buttons",
                    buttons: ["어린이집 정보탐색", "내 아이 정보탐색", "그만하기"]
                  }
              }
              render json: @msg, status: :ok
    
    # # 어린이집 정보탐색
    # elsif @kakao.lastQuestion =="어린이집 정보탐색" && !(@result.include?("그만"))
    
    #   @sidoArr = Array.new 
    #   @sidoArr = ["전체","서울특별시", "부산광역시", "대구광역시", "인천광역시", "광주광역시", "대전광역시", "울산광역시", "세종특별자치시", "경기도", "강원도","충청북도","충청남도","전라북도","전라남도","경상북도","경상남도","제주도", "그만하기"]
        
    #   # 방법 나누기
    #   # 지역
    #   if @result == "지역으로 검색"
    #     @msg ={
    #       message: {text: "원하는 시/도 지역을 선택해주세요."},
    #       keyboard: { type: "buttons",
    #                   buttons: @sidoArr
    #                 }
    #           }
    #           render json: @msg, status: :ok
    #           @kakao.lastQuestion = "시도검색"
    #           @kakao.save
              
      
    #   # 이름
    #   elsif @result =="이름으로 검색"
      
    #   end
    
    # # 시도 검색
    # elsif @kakao.lastQuestion =="시도검색" && !(@result.include?("그만")) && @result != "전체"
    #   @sidoArr = ["전체","서울특별시", "부산광역시", "대구광역시", "인천광역시", "광주광역시", "대전광역시", "울산광역시", "세종특별자치시", "경기도", "강원도","충청북도","충청남도","전라북도","전라남도","경상북도","경상남도","제주도", "그만하기"]
    #   @sigunArr =  Array.new
    #   sigun = Region.where("sidoname like ?",@result) # 원하는 시도 에 해당하는 지역 정보 다가져오기
      
    #   # 시군구 이름 다 넣기
    #   sigun.each do |sig|
    #     @sigunArr.push(sig.sigunname)
    #   end
      
    #   @sigunArr.push("그만하기")
      
    #   @msg = {
    #       message: {text: "원하는 시/군/구 지역을 선택해주세요."},
    #       keyboard: { type: "buttons",
    #                   buttons: @sigunArr
    #                 }
    #           }
    #           render json: @msg, status: :ok
    #           @kakao.lastQuestion = "시군구검색"
    #           @kakao.sido = @result
    #           @kakao.save
              
    # # 전체검색
    # elsif @kakao.lastQuestion =="시도검색" && !(@result.include?("그만")) && @result == "전체"
    #   @kindergarden = Kindergarden.all[0..9]
    #   @kdg = @kindergarden
    #   @arr = Array.new
      
    #   @kindergarden.each do |k|
    #     @arr.push(k.crname+ "의 정보보기 : "+"http://info.childcare.go.kr/info/pnis/search/preview/SummaryInfoSlPu.jsp?flag=YJ&STCODE_POP="+k.stcode+"&CRNAMETITLE="+k.crname)
    #   end
      
    #   @msg = {
    #     message: {text: "원하시는 어린이집을 클릭해주세요\n#{@arr[0]}\n#{@arr[1]}\n#{@arr[2]}\n#{@arr[3]}\n#{@arr[4]}\n#{@arr[5]}\n#{@arr[6]}\n#{@arr[7]}\n..."},
    #     keyboard: { type: "buttons",
    #                 buttons: ["어린이집 정보탐색", "내 아이 정보탐색", "그만하기"]
    #               }
    #         }
    #         render json: @msg, status: :ok
    #         @kakao.lastQuestion = ""
    #         @kakao.save
      
    
    # # 시군구 검색 
    # elsif (@kakao.lastQuestion == "시군구검색" && !(@result.include?("그만")))
    #   @msg = {
    #       message: {text: "#{@kakao.sido}, #{@result} 로 검색하시겠습니까?"},
    #       keyboard: { type: "buttons",
    #                   buttons: ["검색", "이름 추가 검색", "그만하기"]
    #                 }
    #           }
    #           render json: @msg, status: :ok
    #           @kakao.lastQuestion = "검색하기"
    #           @kakao.sigun = @result
    #           @kakao.save
              
    # # 검색하기
    # elsif @kakao.lastQuestion == "검색하기" && !(@result.include?("그만"))
    #   if @result == "검색"
        
    #     # 둘다 전체가 아닌경우
    #     if @kakao.sido !=  "전체" && @kakao.sigun != "전체"
    #       @kdg = Kindergarden.where("sidoname like ? AND sigunguname like ?",@kakao.sido, @kakao.sigungu)
        
    #     # 시군구가 전체인 경우
    #     elsif @kakao.sido !=  "전체" && @kakao.sigun == "전체"
    #       @kdg = Kindergarden.where("sidoname like ?",@kakao.sido)
        
    #     end
        
    #     @msg = {
    #       message: {text: ""},
    #       keyboard: { type: "buttons",
    #                   buttons: ["검색", "이름 추가 검색", "그만하기"]
    #                 }
    #           }
    #           render json: @msg, status: :ok
    #           @kakao.lastQuestion = "검색하기"
    #           @kakao.sigun = @result
    #           @kakao.save
      
    #   # 이름 입력
    #   elsif @result == "이름 추가 검색"
    #     @msg = {
    #       message: {text: "검색할 어린이집의 이름을 입력하세요."},
    #       keyboard: { type: "text"}
    #           }
               
    #         render json: @msg, status: :ok
    #         @kakao.lastQuestion = "이름 추가입력"
    #         @kakao.sigun = @result
    #         @kakao.save
              
    #   end
              
    # 기능 1 ---------------------------------------------------------------------------끝
    
    # 기능 2 ---------------------------------------------------------------------------시작
    elsif @result == "내 아이 정보탐색"
      # 로그인 하지 않았을 경우
      if @kakao.login == false
      @msg = {
        message: {text: "해당 서비스를 이용하기 위해서는 로그인이 필요합니다."},
        keyboard: {
                    type: "buttons",
                    buttons: ["로그인", "처음부터 다시 시작"]
                   }
              }
              render json: @msg, status: :ok
      
      # 로그인 하였을 경우
      else        
        @user = User.find_by_email(@kakao.email)
        @children = Child.where("parent_id like ?", @user.id )
        
        array = []
        @children.each do |c| 
          array.push(c.name)
        end
        array.push("그만하기")
        
        @msg = {
        message: {text: "보고 싶은 내 아이를 선택해주세요"},
        keyboard: { type: "buttons",
                    buttons: array
                    
                  }
              }
              render json: @msg, status: :ok
              @kakao.lastQuestion = "childSelect" #질문 컬럼넣기
              @kakao.save
      end
      
      # 아이선택
    elsif @kakao.lastQuestion == "childSelect" && !(@result.include?("그만"))
      @msg = {
        message: {text: "#{@result} 어린이의 어떤 정보를 보시겠습니까?"},
        keyboard: {
                    type: "buttons",
                    buttons: ["기본 정보보기", "버스 승하차 정보보기","식중독 위험 정보보기","미세먼지 정보보기", "그만하기"]
                   }
              }
              render json: @msg, status: :ok
              @kakao.lastQuestion = "childOption"
              @kakao.selChild = @result # 선택아이
              @kakao.save
      
      # 아이 기능
    elsif @kakao.lastQuestion == "childOption" && !(@result.include?("그만"))
      
      @child = Child.find_by_name(@kakao.selChild)
      @kindergarden = Kindergarden.find_by_id(@child.kindergarden_id)
      childbus = Childbus.where("child_id like ?", @child.id).order("created_at DESC")
      
      # 기본 정보보기
      if @result == "기본 정보보기"
      @msg = {
        message: {text: "#{@child.name} 어린이의 기본 정보\n소속 : #{@kindergarden.crname}\n나이 : #{@child.age}\n성별 : #{@child.gender}자\n담당교사 : #{User.find(@child.teacher_id).username}\n학부모 : #{User.find(@child.parent_id).username}"},
        keyboard: {
                    type: "buttons",
                    buttons: ["기본 정보보기", "버스 승하차 정보보기", "식중독 위험 정보보기","미세먼지 정보보기", "그만하기"]
                   }
              }
              render json: @msg, status: :ok
              @kakao.lastQuestion = "childOption"
              @kakao.save
      
      
      # 버스 승하차 정보보기
      elsif @result == "버스 승하차 정보보기"
      
        # 버스 승하차 정보가 많으면 최근 2개만
        if childbus.size >=2
          @childbus = childbus[0..1]
          @msg = {
            message: {text: "#{@child.name} 어린이의 버스 승하차 정보\n#{@childbus[0].created_at}에 #{@childbus[0].boarding}하였습니다\n#{@childbus[1].created_at}에 #{@childbus[1].boarding}하였습니다"},
            keyboard: {
                        type: "buttons",
                        buttons: ["기본 정보보기", "버스 승하차 정보보기", "식중독 위험 정보보기", "미세먼지 정보보기", "그만하기"]
                       }
                  }
                  render json: @msg, status: :ok
                  @kakao.lastQuestion = "childOption"
                  @kakao.save
                  
        # 버스 승하차 정보가 1개일 경우
        elsif childbus.size == 1
        
         @msg = {
            message: {text: "#{@child.name} 어린이의 버스 승하차 정보\n#{childbus[0].created_at}에 #{childbus[0].boarding}하였습니다"},
            keyboard: {
                        type: "buttons",
                        buttons: ["기본 정보보기", "버스 승하차 정보보기","식중독 위험 정보보기","미세먼지 정보보기", "그만하기"]
                       }
                  }
                  render json: @msg, status: :ok
                  @kakao.lastQuestion = "childOption"
                  @kakao.save
          # 버스 승하차 정보가 없을 경우
          else
            @msg = {
            message: {text: "#{@child.name} 어린이의 버스 승하차 정보\n최근 알림이 없습니다. "},
            keyboard: {
                        type: "buttons",
                        buttons: ["기본 정보보기", "버스 승하차 정보보기", "식중독 위험 정보보기","미세먼지 정보보기", "그만하기"]
                       }
                  }
                  render json: @msg, status: :ok
                  @kakao.lastQuestion = "childOption"
                  @kakao.save
        end
        
      # 식중독알리미 
     elsif @result == "식중독 위험 정보보기"
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
    
      @msg = {
        message: {text: "식중독 위험정보 보기\n오늘 : #{@result_1}\n내일 : #{@result_2}\n모레 : #{@result_3}\n(관심<주의<위험<경고)"},
        keyboard: {
                    type: "buttons",
                    buttons: ["기본 정보보기", "버스 승하차 정보보기", "식중독 위험 정보보기","미세먼지 정보보기", "그만하기"]
                   }
              }
              render json: @msg, status: :ok
              @kakao.lastQuestion = "childOption"
              @kakao.save
     # end
      
    # 미세먼지 알리미 
    elsif @result == "미세먼지 정보보기"
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
    
      @msg = {
        message: {text: "미세먼지 정보보기\n#{@kindergarden.sidoname}\n미세먼지 : #{@todayDust1}\n초미세먼지 : #{@todayDust2}\n(좋음<보통<나쁨<매우나쁨)"},
        keyboard: {
                    type: "buttons",
                    buttons: ["기본 정보보기", "버스 승하차 정보보기", "식중독 위험 정보보기", "미세먼지 정보보기","그만하기"]
                  }
              }
              render json: @msg, status: :ok
              @kakao.lastQuestion = "childOption"
              @kakao.save
      end
        
    # 기능 2 ---------------------------------------------------------------------------끝
    # 그만하기
    elsif @result.include? "그만"
      @msg = {
        message: {text: "이용해주셔서 감사합니다! 또 방문해주세요\n처음부터 다시 시작을 원하시면 '!홈' 을 입력해주세요"},
        keyboard:{
                  type: "text"
                 }
              }
              render json: @msg, status: :ok
              @kakao.lastQuestion =""
              @kakao.selChild = ""
              @kakao.save
              
    
    # 처음부터 다시 시작
    elsif ((@result.include? "처음부터 다시 시작") | (@result == "!홈"))
      @msg ={ 
        message: {text: "처음부터 다시 시작합니다! 원하시는 기능을 선택해주세요."},            
        keyboard: {type: "buttons",
                   buttons: ["어린이집 정보탐색", "내 아이 정보탐색", "그만하기"]
                  }
             }
          render json: @msg, status: :ok
    
    # 기능 시작
       elsif ((@result.include? "로그인 완료") && (@result == "!홈"))
      @msg ={ 
        message: {text: "원하시는 기능을 선택해주세요."},            
        keyboard: {type: "buttons",
                   buttons: ["어린이집 정보탐색", "내 아이 정보탐색", "그만하기"]
                  }
             }
          render json: @msg, status: :ok
    
    # 텍스트 검색
    elsif @result.include? "텍스트로 검색"
      @msg = {
        message: {text: "텍스트를 입력해주세요!"},
        keyboard: {type:"text"}
             }
              render json: @msg, status: :ok
    
    # 미등록 기능
    else
      @msg = {
        message: {text: "죄송합니다, 현재 기능이 등록되지 않았습니다."},
        keyboard: { type: "buttons",
                    buttons: ["처음부터 다시 시작", "텍스트로 검색", "그만하기"]
                  }
             }
             render json: @msg, status: :ok
    end
    
  end
end
