class BookmarksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_note, only: %i[create destroy]

  # GET /bookmarks
  def index
    @bookmarked_notes = current_user.bookmarked_notes
                                     .includes(:user, :tag, :team)
                                     .order('bookmarks.created_at DESC')
                                     .page(params[:page])
  end

  # POST /bookmarks
  def create
    @bookmark = current_user.bookmarks.build(note_id: @note.id)

    respond_to do |format|
      if @bookmark.save
        format.html { redirect_to request.referer || @note, notice: "ブックマークに追加しました" }
        format.turbo_stream
      else
        format.html { redirect_to request.referer || @note, alert: "ブックマークの追加に失敗しました" }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("bookmark-button-#{@note.id}", partial: "bookmarks/button", locals: { note: @note }) }
      end
    end
  end

  # DELETE /bookmarks/:note_id
  def destroy
    @bookmark = current_user.bookmarks.find_by(note_id: @note.id)
    @bookmark&.destroy!

    respond_to do |format|
      format.html { redirect_to request.referer || @note, status: :see_other, notice: "ブックマークを解除しました" }
      format.turbo_stream
    end
  end

  private

  def set_note
    @note = Note.find(params[:note_id])
  end
end
