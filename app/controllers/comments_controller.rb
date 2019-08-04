class CommentsController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
    @user = User.find_by(id: @post.user_id)
    @comment = @post.comments.build(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      NotificationMailer.comment_mail(@user, @post).deliver_now
      render :index
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.destroy
      render :index
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:content, :post_id, :user_id)
    end
end
