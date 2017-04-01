class GroupsController < ApplicationController
before_action :authenticate_user! , only: [:new,:create,:edit ,:update, :destroy, :join,:quit]
before_action :find_group_and_check_permission, only: [:edit, :update, :destroy]
  def index
    @groups=Group.all

  end

  def show
  @group=Group.find(params[:id])
  @posts=@group.posts.recent.paginate(:page => params[:page], :per_page=>5)
  end

  def edit

  end

  def new
    @group=Group.new
  end

  def create
    @group=Group.new(group_params)
    @group.user=current_user
    if @group.save
      current_user.join!(@group)
      redirect_to groups_path
  else
    render :new
  end
  end

  def update

      if @group.update(group_params)
      then
        redirect_to groups_path, notice: "update Success"
      else
        render :edit
      end


  end

def destroy
  @group.destroy
  flash[:alert]="Group deleted"
  redirect_to groups_path
end


  def join
    @group=Group.find(params[:id])
    if current_user.is_member_of?(@group)
    then
      flash[:warning]="YOu are ready in the group"
    else
      current_user.join!(@group)
      flash[:notice]="Successfully joined the group"
    end
    redirect_to group_path(@group)
  end


  def quit
    @group=Group.find(params[:id])
    if current_user.is_member_of?(@group)
    then
      current_user.quit!(@group)
      flash[:alert]="quit group"
    else
      flash[:warning]="Not a member"
    end
    redirect_to group_path(@group)
  end

  private

  def find_group_and_check_permission
    @group=Group.find(params[:id])

    if current_user != @group.user
      redirect_to root_path, alert: "you have no permission"
    end
  end

  def group_params
    params.require(:group).permit(:title, :description)
  end



end
