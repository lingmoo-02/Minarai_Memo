class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :notes, dependent: :destroy
  has_many :teams, foreign_key: 'owner_id', dependent: :destroy
  has_many :team_memberships, dependent: :destroy
  has_many :joined_teams, through: :team_memberships, source: :team

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
  validates :uid, presence: true, uniqueness: { scope: :provider }

  mount_uploader :avatar, AvatarUploader

  def self.from_omniauth(auth)
    Rails.logger.debug "AUTH: #{auth.inspect}"

    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.name = auth.info.name
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]

      if user.save
        user
      else
        Rails.logger.debug "User save failed: #{user.errors.full_messages}"
        nil
      end
    end
  end

  def self.create_unique_string
    SecureRandom.uuid
  end

  # Team permission checks
  def can_manage_team?(team)
    team.owner_id == id || team_memberships.exists?(team: team, role: [:master, :owner])
  end

  def can_create_tags?(team)
    team.owner_id == id || team_memberships.exists?(team: team, role: [:master, :owner])
  end

  def can_edit_note?(note)
    note.user_id == id || (note.team && can_view_team_notes?(note.team))
  end

  def can_view_team_notes?(team)
    team_memberships.exists?(team: team)
  end

end
