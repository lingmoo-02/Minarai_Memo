class NotesController < ApplicationController
  before_action :set_note, only: %i[ show edit update destroy ]
  before_action :check_note_ownership, only: %i[ show edit update destroy ]

  # GET /notes or /notes.json
  def index
    @notes = current_user.notes
                         .search_by_keyword(search_params[:keyword])
                         .filter_by_tag(search_params[:tag_id])
                         .created_between(parse_date(search_params[:date_from]),
                                         parse_date(search_params[:date_to]))
                         .order(created_at: :desc)
                         .page(params[:page])
  end

  # GET /notes/by_date
  def by_date
    date = Date.parse(search_params[:date])
    @notes = current_user.notes
                         .where('DATE(created_at) = ?', date)
                         .includes(:tag, :user)
                         .order(created_at: :desc)

    respond_to do |format|
      format.turbo_stream
    end
  rescue ArgumentError
    @notes = []
    respond_to do |format|
      format.turbo_stream
    end
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
    @note = current_user.notes.build(note_params)

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
    respond_to do |format|
      if @note.update(note_params)
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
      params.require(:note).permit(:title, :note_image, :note_image_cache, :tag_id, :team_id, :materials, :work_duration, :reflection)
    end

    # 検索パラメータのホワイトリスト
    def search_params
      params.permit(:keyword, :tag_id, :date_from, :date_to, :page, :date)
    end

    # 日付文字列をDateオブジェクトに変換（安全な変換）
    def parse_date(date_string)
      return nil if date_string.blank?
      Date.parse(date_string)
    rescue ArgumentError
      nil
    end
end
