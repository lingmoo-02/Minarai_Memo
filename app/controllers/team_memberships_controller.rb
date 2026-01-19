class TeamMembershipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_team
  before_action :check_manager, only: %i[new create edit update destroy]
  before_action :set_membership, only: %i[edit update destroy]

  # GET /teams/:team_id/memberships
  def index
    @memberships = @team.team_memberships.includes(:user)
  end

  # GET /teams/:team_id/memberships/new
  def new
    @membership = @team.team_memberships.build
  end

  # POST /teams/:team_id/memberships
  def create
    user = User.find_by(email: membership_params[:email])

    if user.nil?
      redirect_to team_memberships_path(@team), alert: "ユーザーが見つかりません"
    elsif @team.team_memberships.exists?(user: user)
      redirect_to team_memberships_path(@team), alert: "すでにチームに参加しています"
    else
      @membership = @team.team_memberships.build(user: user, role: membership_params[:role])

      respond_to do |format|
        if @membership.save
          format.html { redirect_to team_memberships_path(@team), notice: "メンバーを追加しました" }
          format.json { render :show, status: :created, location: @membership }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @membership.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # GET /teams/:team_id/memberships/:id/edit
  def edit
  end

  # PATCH/PUT /teams/:team_id/memberships/:id
  def update
    respond_to do |format|
      if @membership.update(membership_params)
        format.html { redirect_to team_memberships_path(@team), notice: "役割を更新しました" }
        format.json { render :show, status: :ok, location: @membership }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/:team_id/memberships/:id
  def destroy
    @membership.destroy!

    respond_to do |format|
      format.html { redirect_to team_memberships_path(@team), status: :see_other, notice: "メンバーを削除しました" }
      format.json { head :no_content }
    end
  end

  private

  def set_team
    @team = Team.find(params[:team_id])
  end

  def set_membership
    @membership = @team.team_memberships.find(params[:id])
  end

  def check_manager
    redirect_to team_path(@team), alert: "チーム管理者のみ実行できます" unless current_user.can_manage_team?(@team)
  end

  def membership_params
    params.require(:team_membership).permit(:email, :role)
  end
end
