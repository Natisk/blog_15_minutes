# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_comment, only: %i[ show edit update destroy ]
  before_action :set_post

  # GET posts/:post_id/comments or posts/:post_id/comments.json
  def index
    @comments = @post.comments
  end

  # GET posts/:post_id/comments/1 or posts/:post_id/comments/1.json
  def show
  end

  # GET posts/:post_id/comments/new
  def new
    @comment = Comment.new
  end

  # GET posts/:post_id/comments/1/edit
  def edit
  end

  # POST posts/:post_id/comments or posts/:post_id/comments.json
  def create
    @comment = current_user.comments.build(comment_params.merge(post_id: @post.id))

    respond_to do |format|
      if @comment.save
        format.html { redirect_to post_comment_url(@post, @comment), notice: "Comment was successfully created." }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT posts/:post_id/comments/1 or posts/:post_id/comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to post_comment_url(@post, @comment), notice: "Comment was successfully updated." }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE posts/:post_id/comments/1 or posts/:post_id/comments/1.json
  def destroy
    @comment.destroy!

    respond_to do |format|
      format.html { redirect_to post_comments_url(@post), notice: "Comment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def set_post
      @post = Post.find(params[:post_id])
    end

    def comment_params
      params.require(:comment).permit(:body)
    end
end
