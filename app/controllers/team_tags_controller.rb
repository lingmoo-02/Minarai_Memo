class TeamTagsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_team
  before_action :check_creator, only: %i[new create edit update destroy]
  before_action :set_tag, only: %i[edit update destroy]

  # GET /teams/:team_id/tags
  def index
    @tags = @team.tags

    respond_to do |format|
      format.html
      format.json { render json: @tags }
    end
  end

  # GET /teams/:team_id/tags/new
  def new
    @tag = @team.tags.build
  end

  # POST /teams/:team_id/tags
  def create
    @tag = @team.tags.build(tag_params)

    respond_to do |format|
      if @tag.save
        format.html { redirect_to team_tags_path(@team), notice: "タグを作成しました" }
        format.json { render :show, status: :created, location: @tag }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /teams/:team_id/tags/:id/edit
  def edit
  end

  # PATCH/PUT /teams/:team_id/tags/:id
  def update
    respond_to do |format|
      if @tag.update(tag_params)
        format.html { redirect_to team_tags_path(@team), notice: "タグを更新しました" }
        format.json { render :show, status: :ok, location: @tag }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/:team_id/tags/:id
  def destroy
    @tag.destroy!

    respond_to do |format|
      format.html { redirect_to team_tags_path(@team), status: :see_other, notice: "タグを削除しました" }
      format.json { head :no_content }
    end
  end

  private

  def set_team
    @team = Team.find(params[:team_id])
  end

  def set_tag
    @tag = @team.tags.find(params[:id])
  end

  def check_creator
    redirect_to team_tags_path(@team), alert: "師匠以上のみタグを作成・編集できます" unless current_user.can_create_tags?(@team)
  end

  def tag_params
    params.require(:tag).permit(:name)
  end
end
