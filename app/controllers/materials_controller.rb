class MaterialsController < ApplicationController
  before_action :authenticate_user!

  # JSON APIエンドポイント: チームIDに応じて資材一覧を返す
  def index
    team_id = params[:team_id]

    materials = if team_id.present?
      Material.for_team(team_id).or(Material.where(user_id: current_user.id, team_id: nil))
    else
      Material.where(user_id: current_user.id, team_id: nil)
    end

    render json: materials.pluck(:id, :name).map { |id, name| { id: id, name: name } }
  end
end
