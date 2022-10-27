class PostsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  def index
    @posts = policy_scope(Post)
    @contact = Contact.new
  end

  def show
    @post = Post.find_by(clean_url: params[:clean_url])
    authorize @post
    @contact = Contact.new
  end

  def create
    @post = Post.new(post_params)
    authorize @post
    if @post.save
      redirect_to admin_posts_path
    else
      render new_admin_post_path, status: :unprocessable_entity
    end
  end

  def update
    @post = Post.find(params[:id])
    authorize @post
    @post.update(post_params)
    if @post.save
      redirect_to admin_posts_path
    else
      render edit_admin_post_path, status: :unprocessable_entity
    end
  end

  def destroy
    @post = Post.find(params[:id])
    authorize @post
    @post.destroy
    redirect_to admin_posts_path, status: :see_other
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :publish, :photo, :category_list, :clean_url)
  end
end
