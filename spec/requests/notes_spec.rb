require 'rails_helper'

RSpec.describe "Notes", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:note_image) { fixture_file_upload(Rails.root.join('spec/fixtures/files/test_note_image.jpg'), 'image/jpeg') }

  before { sign_in user }

  describe "GET /notes" do
    let!(:user_notes) { create_list(:note, 3, :with_image, user: user) }
    let!(:other_notes) { create_list(:note, 2, :with_image, user: other_user) }

    it "ログインユーザーのノート一覧を表示する" do
      get notes_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /notes/:id" do
    let(:note) { create(:note, :with_image, user: user) }

    context "自分のノートの場合" do
      it "ノート詳細を表示する" do
        get note_path(note)
        expect(response).to have_http_status(:success)
      end
    end

    context "他人のノートの場合" do
      let(:other_note) { create(:note, :with_image, user: other_user) }

      it "リダイレクトされる" do
        get note_path(other_note)
        expect(response).to redirect_to(notes_path)
      end
    end
  end

  describe "GET /notes/new" do
    it "新規作成フォームを表示する" do
      get new_note_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /notes" do
    let(:valid_params) do
      {
        note: {
          title: "新しいノート",
          materials: "木材、釘",
          work_duration: 120,
          reflection: "良い経験でした",
          note_image: note_image
        }
      }
    end

    context "有効なパラメータの場合" do
      it "ノートが作成される" do
        expect {
          post notes_path, params: valid_params
        }.to change(Note, :count).by(1)
      end

      it "作成後にノート詳細ページにリダイレクトする" do
        post notes_path, params: valid_params
        expect(response).to redirect_to(note_path(Note.last))
      end
    end

    context "無効なパラメータの場合" do
      let(:invalid_params) { { note: { title: "" } } }

      it "ノートが作成されない" do
        expect {
          post notes_path, params: invalid_params
        }.not_to change(Note, :count)
      end

      it "newテンプレートを再表示する" do
        post notes_path, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "GET /notes/:id/edit" do
    let(:note) { create(:note, :with_image, user: user) }

    context "自分のノートの場合" do
      it "編集フォームを表示する" do
        get edit_note_path(note)
        expect(response).to have_http_status(:success)
      end
    end

    context "他人のノートの場合" do
      let(:other_note) { create(:note, :with_image, user: other_user) }

      it "リダイレクトされる" do
        get edit_note_path(other_note)
        expect(response).to redirect_to(notes_path)
      end
    end
  end

  describe "PATCH /notes/:id" do
    let(:note) { create(:note, :with_image, user: user) }
    let(:update_params) { { note: { title: "更新されたタイトル" } } }

    context "自分のノートの場合" do
      it "ノートが更新される" do
        patch note_path(note), params: update_params
        note.reload
        expect(note.title).to eq("更新されたタイトル")
      end

      it "更新後にノート詳細ページにリダイレクトする" do
        patch note_path(note), params: update_params
        expect(response).to redirect_to(note_path(note))
      end
    end

    context "他人のノートの場合" do
      let(:other_note) { create(:note, :with_image, user: other_user) }

      it "リダイレクトされる" do
        patch note_path(other_note), params: update_params
        expect(response).to redirect_to(notes_path)
      end
    end
  end

  describe "DELETE /notes/:id" do
    let!(:note) { create(:note, :with_image, user: user) }

    context "自分のノートの場合" do
      it "ノートが削除される" do
        expect {
          delete note_path(note)
        }.to change(Note, :count).by(-1)
      end

      it "削除後にノート一覧ページにリダイレクトする" do
        delete note_path(note)
        expect(response).to redirect_to(notes_path)
      end
    end

    context "他人のノートの場合" do
      let!(:other_note) { create(:note, :with_image, user: other_user) }

      it "リダイレクトされる" do
        delete note_path(other_note)
        expect(response).to redirect_to(notes_path)
      end

      it "ノートが削除されない" do
        expect {
          delete note_path(other_note)
        }.not_to change(Note, :count)
      end
    end
  end

  context "未認証の場合" do
    before { sign_out user }

    it "indexアクションでエラーが発生する" do
      # NotesControllerがcurrent_userを使用するため、エラーが発生する
      expect {
        get notes_path
      }.to raise_error(NoMethodError)
    end
  end
end
