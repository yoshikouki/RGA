class BattlesController

  EXP_CONSTANT = 2
  GOLD_CONSTANT = 3

  # 戦闘イベント（交互に攻撃し合う）
  def battle(**params)
    set_character(params)

    loop do
      @user.attack(@enemy)
      break if battle_end?
      @enemy.attack(@user)
      break if battle_end?
    end

    battle_judgement
  end

  private

    def set_character(**params)
      @user = params[:user]
      @enemy = params[:enemy]
    end

    # 戦闘終了フラグ
    def battle_end?
      @user.hp <= 0 || @enemy.hp <= 0
    end

    # 戦闘結果
    def battle_judgement
      if user_won?
        reward = calculate_battle_reward
        puts <<~EOS
        #{@enemy.name}は倒れた。
        #{@enemy.name}との戦闘に勝利した！
        Exp #{reward[:exp]}
        Gold #{reward[:gold]}
        を獲得した！
        EOS
      else
        puts <<~EOS
        #{@user.name}は倒れた。
        #{@enemy.name}との戦闘に敗北した...
        EOS
      end
    end

    # 戦闘結果の判定
    def user_won?
      @user.hp > 0
    end

    # 戦闘報酬の計算
    def calculate_battle_reward
      exp = (@enemy.str + @enemy.vit) * EXP_CONSTANT
      gold = (@enemy.max_hp) * GOLD_CONSTANT
      reward = { exp: exp, gold: gold }
    end
end