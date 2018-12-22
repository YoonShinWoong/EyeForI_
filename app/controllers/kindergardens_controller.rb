class KindergardensController < ApplicationController
  
  # 검색하기 ---------------------------------------------------------------------
  def search
    
    @kindergardens = Kindergarden.where("crname like ?", "%#{params[:input_name]}%")
    @kindergarden_all = Kindergarden.all
     
     # 각 시도 별 파싱하기
    @sidoArr = Array.new 
    @sidoArr = ["전체","서울특별시", "부산광역시", "대구광역시", "인천광역시", "광주광역시", "대전광역시", "울산광역시", "세종특별자치시", "경기도", "강원도","충청북도","충청남도","전라북도","전라남도","경상북도","경상남도","제주도"]
    @sigunArr = Array.new(18) { Array.new(0)} 
    
    # 2차원 배열 행 값 
    i=0
    
    #url 처리해서 배열에다가 각 구 이름 집어넣기-->
    @sidoArr.each do |s|
    
        # region 모델에서 해당 시도로 찾아와서-->
        sigun = Region.where("sidoname like ?","#{s}") 
        
        @sigunArr[i].push("전체")
        
        # 해당 시도 모델에시군네임 하나씩 가져와서 저장 
        sigun.each do |sig|
            @sigunArr[i].push(sig.sigunname)
        end
        
        i= i+1
        
    end
    
  end
  
  # 검색결과 ---------------------------------------------------------------------
  def search_result
    #order("created_at DESC")
    @page = params[:page].to_i # 숫자 카운트 용
    @kindergardens = Kindergarden.where("crname like ?", "%#{params[:input_name]}%").page(params[:page]).per(10)
  end
  
  # 어린이집 상세정보보기 ---------------------------------------------------------------------
  def show
  end
  
  # 내부 위험 정보 수정하기 ---------------------------------------------------------------------
  def inEdit
    
    # 아이디 찾아오기
    @kindergarden = Kindergarden.find(params[:id])

    
  end
  
  # 내부 위험 정보 수정하기 ---------------------------------------------------------------------
  def inUpdate
    
    # 아이디 찾아오기
    @kindergarden = Kindergarden.find(params[:id])
    
    # 내부 정보 불러와서 저장하기
    @kindergarden.medicine = params[:medicine]
    @kindergarden.ramp = params[:ramp]
    @kindergarden.healthedu = params[:healthedu]
    @kindergarden.safetyedu = params[:safetyedu]
    @kindergarden.healthcheck = params[:healthcheck]
    @kindergarden.vaccination = params[:vaccination]
    
    @kindergarden.save
    
    # redirect_to "/kindergardens/show/#{@kindergarden.id}"
    
  end
  
  # 무한스크롤
  def ajaxCall
    count = params[:count].to_i
    @item = Post.all.at(count)
    @return_value = {
      "id" => @item.id, 
      "username" => @item.user_id, 
      "title" => @item.title, 
      "time" => @item.created_at
    }
    render json: @return_value
  end
  
  def getSigun
     # 각 시도 별 파싱하기
    @sidoArr = Array.new 
    @sidoArr = ["전체","서울특별시", "부산광역시", "대구광역시", "인천광역시", "광주광역시", "대전광역시", "울산광역시", "세종특별자치시", "경기도", "강원도","충청북도","충청남도","전라북도","전라남도","경상북도","경상남도","제주도"]
    @sigunArr = Array.new(18) { Array.new(0)} 
    
    # 2차원 배열 행 값 
    i=0
    
    #url 처리해서 배열에다가 각 구 이름 집어넣기-->
    @sidoArr.each do |s|
    
        # region 모델에서 해당 시도로 찾아와서-->
        sigun = Region.where("sidoname like ?","#{s}") 
        
        @sigunArr[i].push("전체")
        
        # 해당 시도 모델에시군네임 하나씩 가져와서 저장 
        sigun.each do |sig|
            @sigunArr[i].push(sig.sigunname)
        end
        
        i= i+1
        
    end
    
    render json: @rev = {
      sidoArr: @sidoArr,
      sigunArr: @sigunArr
    }
  end
  
  def getAccident
    @acci = Array.new
    @kind = Kindergarden.find(params[:id])
    
    @kind.each do |k|
      @acci.push(Frequent.find(k.fre.to_i))
    end
    
    render json: @rev={ acci: @acci }
  end
  
  def getPub
    @pub = Array.new
    @kind = Kindergarden.find(params[:id])
    
    @kin = @kin.dan
    @kin.each do |k|
      @pub.push(Dangers.find(k.to_i))
    end
    
    render json: @rev={ pub: @pub }
  end
  
  def getSmoke
    
  end
  
  def getSchool
    @scz = Array.new
    @kind = Kindergarden.find(params[:id])
    
    @kind.each do |k|
      @scz.push(SchoolZone.find(k.sch.to_i))
    end
    
    render json: @rev={ sz: @scz }
  end
  
  def infiscroll
    idx = params[:index].to_i
    @kind = Kindergarden.all[(idx+1)..(idx+3)]

    @rev = {
      "kind" => @kind
    }
    
    render json: @rev
  end
  
  def gotoposi
    @kin = Kindergarden.find(params[:id])
    
    @rev = {
      x: @kin.la,
      y: @kin.lo,
      kin: @kin
    }
    render json: @rev
  end
  
  def getKinder
    
    if params[:sido] != "전체" && params[:sigu] != "전체" 
      @kinder = Kindergarden.where("sidoname like ? and sigunguname like ? and crname like ?", "%#{params[:sido]}%","%#{params[:sigu]}%","%#{params[:crname]}%")
    elsif params[:sido] != "전체" && params[:sigu] == "전체"
      @kinder = Kindergarden.where("sidoname like ? and crname like ?","%#{params[:sido]}%","%#{params[:crname]}%")[0..30]
    else
      @kinder = Kindergarden.where("crname like ?","%#{params[:crname]}%")[0..30]
    end
    @rev = {
      "kind" => @kinder
    }
    
    render json: @rev
  end
  
  def gotoform
    @id = params[:id]
    
    name = Kindergarden.find(@id).crname
    
    @rev={
      name: name,
      id: @id
    }
    
    render json: @rev
  end
end