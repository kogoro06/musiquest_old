class SessionsController < ApplicationController
  def new
    redirect_to RSpotify.authorize_url(scope: 'user-read-private user-read-email')
  end

  def create
    # 認証情報を取得
    user = RSpotify::User.new(request.env['omniauth.auth'])

    # セッションにユーザー情報を保存
    session[:user_id] = user.id

    redirect_to root_path
  end
end
