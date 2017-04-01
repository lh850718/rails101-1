class Account::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_postuser_and_check_permission, only: [:edit, :update, :destroy]
    def index
      @posts=current_user.posts
    end



    def edit

    end

    def update

        if @post.update(post_params)
        then
          redirect_to account_posts_path, notice: "update Success"
        else
          render :edit
        end


    end

  def destroy
    @post.destroy
    flash[:alert]="Post deleted"
    redirect_to account_posts_path
  end


  private

  def find_postuser_and_check_permission
    @post=post.find(params[:id])

    if current_user != @post.user
      redirect_to root_path, alert: "you have no permission"
    end
  end

  def post_params
    params.require(:post).permit(:content)
  end

end
