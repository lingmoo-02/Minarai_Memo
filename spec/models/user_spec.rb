require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーション' do
    subject { build(:user) }

    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(50) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_presence_of(:password) }
    it { should validate_presence_of(:uid) }
    it { should validate_uniqueness_of(:uid).scoped_to(:provider) }
  end

  describe '関連付け' do
    it { should have_many(:notes).dependent(:destroy) }
    it { should have_many(:teams).with_foreign_key('owner_id').dependent(:destroy) }
    it { should have_many(:team_memberships).dependent(:destroy) }
    it { should have_many(:joined_teams).through(:team_memberships).source(:team) }
    it { should have_many(:bookmarks).dependent(:destroy) }
    it { should have_many(:bookmarked_notes).through(:bookmarks).source(:note) }
  end

  describe '#can_manage_team?' do
    let(:owner) { create(:user) }
    let(:master) { create(:user) }
    let(:apprentice) { create(:user) }
    let(:team) { create(:team, owner: owner) }

    before do
      create(:team_membership, team: team, user: master, role: :master)
      create(:team_membership, team: team, user: apprentice, role: :apprentice)
    end

    it 'オーナーはtrueを返す' do
      expect(owner.can_manage_team?(team)).to be true
    end

    it 'マスターはtrueを返す' do
      expect(master.can_manage_team?(team)).to be true
    end

    it '見習いはfalseを返す' do
      expect(apprentice.can_manage_team?(team)).to be false
    end
  end

  describe '#can_view_team_notes?' do
    let(:team_owner) { create(:user) }
    let(:team_member) { create(:user) }
    let(:non_member) { create(:user) }
    let(:team) { create(:team, owner: team_owner) }

    before do
      create(:team_membership, team: team, user: team_member, role: :apprentice)
      create(:team_membership, team: team, user: team_owner, role: :owner)
    end

    it 'メンバーはtrueを返す' do
      expect(team_member.can_view_team_notes?(team)).to be true
    end

    it '非メンバーはfalseを返す' do
      expect(non_member.can_view_team_notes?(team)).to be false
    end

    it 'オーナーはtrueを返す' do
      expect(team_owner.can_view_team_notes?(team)).to be true
    end
  end

  describe '#bookmarked?' do
    let(:user) { create(:user) }
    let(:note) { create(:note, :with_image, user: user) }

    context 'ブックマーク済みの場合' do
      before { create(:bookmark, user: user, note: note) }

      it 'trueを返す' do
        expect(user.bookmarked?(note)).to be true
      end
    end

    context 'ブックマークしていない場合' do
      it 'falseを返す' do
        expect(user.bookmarked?(note)).to be false
      end
    end
  end
end
