class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]
  
  has_many :notes, dependent: :destroy
  
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true

  validates :uid, presence: true, uniqueness: { scope: :provider }, if: -> { uid.present? }

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

end
