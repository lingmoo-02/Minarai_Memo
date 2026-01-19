class TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_team, only: %i[show edit update destroy]
  before_action :check_owner, only: %i[edit update destroy]

  # GET /teams
  def index
    @teams = current_user.teams.page(params[:page])
  end

  # GET /teams/:id
  def show
  end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # POST /teams
  def create
    @team = current_user.teams.build(team_params)

    respond_to do |format|
      if @team.save
        format.html { redirect_to @team, notice: "チームを作成しました" }
        format.json { render :show, status: :created, location: @team }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /teams/:id/edit
  def edit
  end

  # PATCH/PUT /teams/:id
  def update
    respond_to do |format|
      if @team.update(team_params)
        format.html { redirect_to @team, notice: "チームを更新しました" }
        format.json { render :show, status: :ok, location: @team }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/:id
  def destroy
    @team.destroy!

    respond_to do |format|
      format.html { redirect_to teams_path, status: :see_other, notice: "チームを削除しました" }
      format.json { head :no_content }
    end
  end

  private

  def set_team
    @team = Team.find(params[:id])
  end

  def check_owner
    redirect_to teams_path, alert: "チーム管理者のみアクセスできます" unless @team.owner_id == current_user.id
  end

  def team_params
    params.require(:team).permit(:name, :description)
  end
end
