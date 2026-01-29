require 'rails_helper'

RSpec.describe Note, type: :model do
  describe 'バリデーション' do
    subject { build(:note, :with_image) }

    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_most(255) }
    it { should validate_presence_of(:note_image) }
    it { should validate_presence_of(:materials) }
    it { should validate_length_of(:materials).is_at_most(500) }
    it { should validate_presence_of(:work_duration) }
    it { should validate_numericality_of(:work_duration).only_integer.is_greater_than(0).is_less_than_or_equal_to(480) }
    it { should validate_presence_of(:reflection) }
    it { should validate_length_of(:reflection).is_at_most(65_535) }
  end

  describe '関連付け' do
    it { should belong_to(:user) }
    it { should belong_to(:team).optional }
    it { should belong_to(:tag).optional }
    it { should belong_to(:material).optional }
    it { should have_many(:bookmarks).dependent(:destroy) }
    it { should have_many(:bookmarked_by_users).through(:bookmarks).source(:user) }
  end

  describe '#work_duration_formatted' do
    it '時間と分の両方がある場合' do
      note = build(:note, work_duration: 125)
      expect(note.work_duration_formatted).to eq('2時間5分')
    end

    it '時間のみの場合' do
      note = build(:note, work_duration: 120)
      expect(note.work_duration_formatted).to eq('2時間')
    end

    it '分のみの場合' do
      note = build(:note, work_duration: 45)
      expect(note.work_duration_formatted).to eq('45分')
    end

    it 'work_durationがnilの場合' do
      note = build(:note, work_duration: nil)
      expect(note.work_duration_formatted).to be_nil
    end
  end

  describe '#materials_array' do
    it '日本語カンマ区切りを配列に変換する' do
      note = build(:note, materials: '木材、釘、のこぎり')
      expect(note.materials_array).to eq(['木材', '釘', 'のこぎり'])
    end

    it '英語カンマ区切りを配列に変換する' do
      note = build(:note, materials: 'wood,nails,saw')
      expect(note.materials_array).to eq(['wood', 'nails', 'saw'])
    end

    it '空白を除去する' do
      note = build(:note, materials: '木材 、 釘 、 のこぎり')
      expect(note.materials_array).to eq(['木材', '釘', 'のこぎり'])
    end

    it 'materialsがblankの場合は空配列を返す' do
      note = build(:note, materials: '')
      expect(note.materials_array).to eq([])
    end
  end

  describe 'スコープ' do
    describe '.search_by_keyword' do
      let(:user) { create(:user) }
      let!(:note1) { create(:note, :with_image, user: user, title: 'テスト作品', materials: '木材', reflection: '良い経験') }
      let!(:note2) { create(:note, :with_image, user: user, title: '別の作品', materials: 'テスト資材', reflection: '反省') }
      let!(:note3) { create(:note, :with_image, user: user, title: '関係ない', materials: '鉄', reflection: '普通') }

      it 'タイトルで検索できる' do
        results = Note.search_by_keyword('テスト')
        expect(results).to include(note1)
        expect(results).not_to include(note3)
      end

      it '資材で検索できる' do
        results = Note.search_by_keyword('テスト資材')
        expect(results).to include(note2)
      end

      it 'keywordがblankの場合は全件返す' do
        results = Note.search_by_keyword('')
        expect(results.count).to eq(3)
      end
    end

    describe '.filter_by_tag' do
      let(:tag1) { create(:tag, name: 'タグ1') }
      let(:tag2) { create(:tag, name: 'タグ2') }
      let(:user) { create(:user) }
      let!(:note1) { create(:note, :with_image, user: user, tag: tag1) }
      let!(:note2) { create(:note, :with_image, user: user, tag: tag2) }
      let!(:note3) { create(:note, :with_image, user: user, tag: nil) }

      it '指定したタグのノートを返す' do
        results = Note.filter_by_tag(tag1.id)
        expect(results).to include(note1)
        expect(results).not_to include(note2, note3)
      end

      it 'tag_idがblankの場合は全件返す' do
        results = Note.filter_by_tag(nil)
        expect(results.count).to eq(3)
      end
    end

    describe '.created_between' do
      let(:user) { create(:user) }
      let!(:old_note) { create(:note, :with_image, user: user, created_at: 10.days.ago) }
      let!(:recent_note) { create(:note, :with_image, user: user, created_at: 2.days.ago) }

      it '日付範囲でフィルタできる' do
        results = Note.created_between(5.days.ago.to_date, Date.today)
        expect(results).to include(recent_note)
        expect(results).not_to include(old_note)
      end

      it '開始日のみ指定した場合' do
        results = Note.created_between(5.days.ago.to_date, nil)
        expect(results).to include(recent_note)
        expect(results).not_to include(old_note)
      end

      it '終了日のみ指定した場合' do
        results = Note.created_between(nil, 5.days.ago.to_date)
        expect(results).to include(old_note)
        expect(results).not_to include(recent_note)
      end
    end
  end
end
