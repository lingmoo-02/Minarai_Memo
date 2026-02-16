class StaticPagesController < ApplicationController
  def top
    redirect_to profile_path if user_signed_in?
  end

  def terms; end

  def privacy; end
end
