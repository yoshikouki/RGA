# メッセージモジュール
module MessageDialog
  # 攻撃時のログ
  # params[:attack_type, :damage]
  def attack_message(**params)
    log = []
    log << "#{@name}の攻撃"
    log << 'クリティカル！' if params[:attack_type] == :critical_attack
    log
  end

  # 被ダメージのログ
  # params[:character, :damage]
  def damage_message(**params)
    target = params[:target]
    damage = params[:damage]

    log = []
    log << "#{target.name}に #{damage}のダメージ！"
    log << "残りHP #{target.hp}"
    log
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

      #{@player.name}は倒れた
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
