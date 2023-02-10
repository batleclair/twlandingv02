class Admin::PostsController < AdminController
  def index
    @posts = Post.all
    authorize @posts if current_user.user_type == 'admin'
  end

  def new
    @post = Post.new
    authorize @post
  end

  def edit
    @post = Post.find(params[:id])
    authorize @post
  end
end
