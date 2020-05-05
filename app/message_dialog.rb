module MessageDialog
  # 攻撃時のログ
  # params[:attack_type]
  def attack_message(**params)
    attack_type = params[:attack_type]

    puts "#{@name}の攻撃"
    puts "必殺攻撃" if attack_type == :special_attack
  end

  # 被ダメージのログ
  # params[:character, :damage]
  def damage_message(**params)
    target = params[:target]
    damage = params[:damage]

    puts <<~EOS
    #{target.name}に #{damage}のダメージ！
    #{target.name} HP: #{target.hp}

    EOS
  end

  # バトル勝利時
  # params[:reward]
  def user_won_message(**params)
    reward = params[:reward]

    puts <<~EOS

    #{@enemy.name}は倒れた
    #{@enemy.name}との戦闘に勝利した！
    Exp #{reward[:exp]}
    Gold #{reward[:gold]}
    を獲得した！

    EOS
  end

  # バトル敗北時
  def user_lost_message
    puts <<~EOS

    #{@user.name}は倒れた
    #{@enemy.name}との戦闘に敗北した...

    EOS
  end

  # バトル中、敵が変身する時
  # params[:name, :init_name]
  def enemy_transform_message(**params)
    before = params[:before_name]
    after = params[:after_name]

    puts <<~EOS
    #{before}は怒っている
    #{before}は#{after}に変身した

    EOS
  end
end