class TeamNotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_team
  before_action :check_member, only: %i[index show]
  before_action :set_note, only: %i[show]

  # GET /teams/:team_id/notes
  def index
    @notes = @team.notes.includes(:tag, :user).order(created_at: :desc).page(params[:page])
  end

  # GET /teams/:team_id/notes/:id
  def show
  end

  private

  def set_team
    @team = Team.find(params[:team_id])
  end

  def check_member
    redirect_to teams_path, alert: "チームメンバーではありません" unless current_user.can_view_team_notes?(@team)
  end

  def set_note
    @note = @team.notes.find(params[:id])
  end
end
