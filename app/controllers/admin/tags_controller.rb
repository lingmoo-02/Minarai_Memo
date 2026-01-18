class Admin::TagsController < ApplicationController
  before_action :require_admin
  before_action :set_tag, only: %i[edit update destroy]

  # GET /admin/tags
  def index
    @tags = Tag.order(created_at: :desc)
  end

  # GET /admin/tags/new
  def new
    @tag = Tag.new
  end

  # POST /admin/tags
  def create
    @tag = Tag.new(tag_params)

    if @tag.save
      redirect_to admin_tags_path, notice: "タグを作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /admin/tags/:id/edit
  def edit
  end

  # PATCH/PUT /admin/tags/:id
  def update
    if @tag.update(tag_params)
      redirect_to admin_tags_path, notice: "タグを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /admin/tags/:id
  def destroy
    @tag.destroy!
    redirect_to admin_tags_path, status: :see_other, notice: "タグを削除しました"
  end

  private

  def require_admin
    unless current_user&.admin?
      redirect_to root_path, alert: "管理者権限が必要です"
    end
  end

  def set_tag
    @tag = Tag.find(params[:id])
  end

  def tag_params
    params.require(:tag).permit(:name)
  end
end
