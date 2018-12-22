class ReceiptsController < ApplicationController
  before_action :authenticate_user!
  
  # 신청하기 -----------------------------------
  def new
    @receipt = Receipt.new
    @receipt.user_id = Child.find(params[:id]).teacher_id
    @receipt.applicant_id = current_user.id
    @receipt.child_id = params[:id].to_i
    
    # 신청한 적 없던 거라면
    if Receipt.where("user_id like ?", "#{current_user.id}").empty? && Receipt.where("child_id like ?", "#{params[:id].to_i}").empty?
      @receipt.save
    end
    
    redirect_to "/receipts/index"
  end
  
  # R 보여주기 -----------------------------------
  def index
    
    # 학부모일 경우
    if current_user.usertype == "parent"
      @receipts = Receipt.where("applicant_id like ?", "#{current_user.id}").order("created_at DESC").page(params[:page]).per(10)
    
    else
      @receipts = Receipt.where("user_id like ?", "#{current_user.id}").order("created_at DESC").page(params[:page]).per(10)
    end
    
  end

  def show
    @receipt = Receipt.find(params[:id])
  end
  
  def accept
    @receipt = Receipt.find(params[:id])
    
    @child = Child.find(@receipt.child_id)
    @child.parent_id = @receipt.applicant_id
    
    @child.save
    @receipt.destroy
    
    redirect_to :back
    
  end
  
  def deny
    @receipt = Receipt.find(params[:id])
    @receipt.destroy
    
    redirect_to :back
  end
end
