# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   session.delete(:current_user_id)
  #   flash[:notice] = "ログアウトしました"
  #   redirect_to root_path
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  # サインイン後のリダイレクト先を指定する
  def after_sign_in_path_for(resource)
    notes_path
  end

  # サインアウト後のリダイレクト先を指定する
  def after_sign_out_path_for(resource_or_scope)
    flash[:notice] = "ログアウトしました"
    root_path
  end
end
