class NotesController < ApplicationController
  before_action :set_note, only: %i[ show edit update destroy ]
  before_action :check_note_ownership, only: %i[ show edit update destroy ]

  # GET /notes or /notes.json
  def index
    @notes = current_user.notes.page(params[:page])
  end

  # GET /notes/1 or /notes/1.json
  def show
  end

  # GET /notes/new
  def new
    @note = Note.new
  end

  # GET /notes/1/edit
  def edit
  end

  # POST /notes or /notes.json
  def create
    @note = current_user.notes.build(note_params.except(:material_name))

    # 新規資材が入力された場合、自動的に作成
    if params[:note][:material_name].present?
      material = Material.find_or_create_by!(
        name: params[:note][:material_name],
        user_id: current_user.id,
        team_id: @note.team_id
      )
      @note.material = material
    end

    respond_to do |format|
      if @note.save
        format.html { redirect_to @note, notice: "ノートが作成されました" }
        format.json { render :show, status: :created, location: @note }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notes/1 or /notes/1.json
  def update
    # 新規資材が入力された場合、自動的に作成
    params_to_update = note_params.except(:material_name)
    if params[:note][:material_name].present?
      material = Material.find_or_create_by!(
        name: params[:note][:material_name],
        user_id: current_user.id,
        team_id: params[:note][:team_id] || @note.team_id
      )
      params_to_update[:material_id] = material.id
    end

    respond_to do |format|
      if @note.update(params_to_update)
        format.html { redirect_to @note, notice: "ノートが更新されました" }
        format.json { render :show, status: :ok, location: @note }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notes/1 or /notes/1.json
  def destroy
    @note.destroy!

    respond_to do |format|
      format.html { redirect_to notes_path, status: :see_other, notice: "ノートを削除しました" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = Note.find(params[:id])
    end

    # Check if the current user owns the note
    def check_note_ownership
      redirect_to notes_path, alert: "このノートへのアクセス権限がありません" unless @note.user_id == current_user.id
    end

    # Only allow a list of trusted parameters through.
    def note_params
      params.require(:note).permit(:title, :note_image, :note_image_cache, :tag_id, :team_id, :material_id, :material_name, :work_duration, :reflection)
    end
end
