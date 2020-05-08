# メッセージモジュール
module MessageDialog
  # 攻撃時のログ
  # params[:attack_type]
  def attack_message(**params)
    attack_type = params[:attack_type]

    Rails.logger.debug "#{@name}の攻撃"
    Rails.logger.debug '必殺攻撃' if attack_type == :special_attack
  end

  # 被ダメージのログ
  # params[:character, :damage]
  def damage_message(**params)
    target = params[:target]
    damage = params[:damage]

    Rails.logger.debug <<~TEXT
      #{target.name}に #{damage}のダメージ！
      #{target.name} HP: #{target.hp}

    TEXT
  end

  # バトル勝利時
  # params[:reward]
  def user_won_message(**params)
    reward = params[:reward]

    Rails.logger.debug <<~TEXT

      #{@enemy.name}は倒れた
      #{@enemy.name}との戦闘に勝利した！
      Exp #{reward[:exp]}
      Gold #{reward[:gold]}
      を獲得した！

    TEXT
  end

  # バトル敗北時
  def user_lost_message
    Rails.logger.debug <<~TEXT

      #{@user.name}は倒れた
      #{@enemy.name}との戦闘に敗北した...

    TEXT
  end

  # バトル中、敵が変身する時
  # params[:name, :init_name]
  def enemy_transform_message(**params)
    before = params[:before_name]
    after = params[:after_name]

    Rails.logger.debug <<~TEXT
      #{before}は怒っている
      #{before}は#{after}に変身した

    TEXT
  end
end
