# 主にユーザーコア情報や認証用のデータを持
# ステータスなどのゲームに関する情報は別モデル？
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable,
         :omniauthable, omniauth_providers: [:twitter]

  # SNS認証用。認証データでUserを検索して返す。ない場合は作成する。
  def self.from_omniauth(auth)
    find_or_create_by(provider: auth['provider'], uid: auth['uid']) do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      user.username = auth['info']['nickname']
    end
  end

  # SNS認証用。SNS認証サインアップ後、認証情報をUser DBに登録。
  def self.new_with_session(params, session)
    if session['devise.user_attributes']
      new(session['devise.user_attributes']) do |user|
        user.attributes = params
      end
    else
      super
    end
  end
end
