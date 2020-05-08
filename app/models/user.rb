require './app/models/character'

# 主にユーザーコア情報や認証用のデータ
class User < ApplicationRecord
  include Character

  # ユーザー認証に関する機能を宣言
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

  def attack(target)
    attack_type = decision_attack_type
    attack_message(attack_type: attack_type)

    damage = calculate_damage(target: target, attack_type: attack_type)
    cause_damage(target: target, damage: damage)
  end

  def decision_attack_type
    attack_num = rand(4)
    if attack_num.zero?
      :special_attack
    else
      :normal_attack
    end
  end
end
