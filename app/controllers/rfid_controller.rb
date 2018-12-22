class RfidController < ApplicationController

  def board
    
    # 해당 아이 찾기
    @child = Child.find_by_rfid(params[:input_rfid])
    
    # 승차일 경우
    if @child.boarding == "하차" || @child.boarding.empty? 
      
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
    
    # 승차 -> 하차
    elsif @child.boarding == "승차"
      @child.boarding = "하차"
      @child.save
      
      tv = Time.now
      
      # 승차 모델 저장
      cb = Childbus.new
      cb.child_id = @child.id
      cb.parent_id = @child.parent_id
      cb.boarding = "하차"
      cb.boardingtime = tv
      cb.save
      redirect_to :back
      
    # 아무것도 아닐때
    else
      redirect_to :back
      
    end
    
  end

end
