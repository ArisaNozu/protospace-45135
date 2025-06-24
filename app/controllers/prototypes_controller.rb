class PrototypesController < ApplicationController

  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :move_to_root_path, only: [:edit, :update, :destroy]

  def index
      @prototypes = Prototype.includes(:user)
  end

  def new
    @prototype = Prototype.new
  end

  
  def create
  @prototype = Prototype.new(prototype_params)
  if @prototype.save
    redirect_to root_path
  else
    render :new            # 失敗時は new ビューを再表示
    end
  end

  def show
    @prototype = Prototype.find(params[:id])
    @comment =  Comment.new           # 新規オブジェクトを代入した
    @comments = @prototype.comments # そのプロトタイプに紐づくコメント一覧を取得するインスタンス変数
  end



  def edit
    @prototype = Prototype.find(params[:id])
  end

  def update
    @prototype = Prototype.find(params[:id])
  if @prototype.update(prototype_params)
    redirect_to prototype_path(@prototype)
  else
    render :edit  
  end
  end


  def destroy
    @prototype = Prototype.find(params[:id])
    @prototype.destroy
    redirect_to root_path
  end


  private
  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end


  def move_to_root_path
  @prototype = Prototype.find(params[:id])
    unless current_user == @prototype.user
    redirect_to root_path
    end
  end


end
