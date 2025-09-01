class ProfilesController < ApplicationController
  before_action :set_user, only: %i[edit update]

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to profile_path, success: t('defaults.flash_message.updated', item: User.model_name.human)
    else
      flash.now['danger'] = t('defaults.flash_message.not_updated', item: User.model_name.human)
      render :edit, status: :unprocessable_entity
    end
  end

  def show
    @notes = current_user.notes

    # 日ごとの累計
    daily = @notes.group_by_day(:created_at, last: 10).count
    sum = 0
    @notes_daily = daily.transform_values { |count| sum += count }
    
    # 週ごとの累計
    weekly = @notes.group_by_week(:created_at, last: 20).count
    sum = 0
    @notes_weekly = weekly.transform_values { |count| sum += count }

    # 月ごとの累計
    monthly = @notes.group_by_month(:created_at, last: 20).count
    sum = 0
    @notes_monthly = monthly.transform_values { |count| sum += count }

    # 年ごとの累計
    yearly = @notes.group_by_year(:created_at, last: 20).count
    sum = 0
    @notes_yearly = yearly.transform_values { |count| sum += count }
  end

  private

  def set_user
    @user = User.find(current_user.id)
  end

  def user_params
    params.require(:user).permit(:email, :name, :avatar, :avatar_cache)
  end
end