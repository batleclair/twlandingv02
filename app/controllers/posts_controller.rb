class PostsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @posts = policy_scope(Post).order(created_at: :desc)
    @last_post = @posts.first
    @posts = @posts.where.not(id: @last_post.id)
    @contact = Contact.new
    add_breadcrumb "Blog", posts_path
  end

  def show
    @post = Post.find_by(slug: params[:slug])
    authorize @post
    @contact = Contact.new
    add_breadcrumb "Blog", posts_path
    add_breadcrumb @post.title, post_path(slug: @post.slug)
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
    params.require(:post).permit(:title, :content, :publish, :photo, :category_list, :slug)
  end
end
