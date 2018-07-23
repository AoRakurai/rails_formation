class BuildsController < ApplicationController
  before_action :authenticate_user!
  def index
    @builds = Build.where(user_id:current_user.id)
  end

  def new    
    @build = Build.new
  end

  def show
    @build = Build.find(params[:id])
  end

  def create
    build_info = {
      "user_id": current_user.id,
      "champion": params[:champion]
    }
    items = {}
    for i in 0..5
      items["item"+i.to_s] = params["item"+i.to_s]
    end
    build_info["items"] = JSON.generate(items)
    @build = Build.new(build_info)
    if @build.save        
        redirect_to builds_path
    else
        puts @build.errors.full_messages
        puts "something goes wrong"
        redirect_to :back #OR render :new
    end
  end

  def destroy
    @build = Build.find(params[:id])
    @build.destroy
    redirect_to builds_path
  end

  private
  def build_params
    params.require(:user_id, :champion).permit(:item0, :item1, :item2, :item3, :item4, :item5)
  end
end
