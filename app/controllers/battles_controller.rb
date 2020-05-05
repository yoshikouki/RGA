class BattlesController
  # 戦闘イベント（交互に攻撃し合う）
  def battle(**params)
    user = params[:user]
    enemy = params[:enemy]

    loop do
      user.attack(enemy)
      break if enemy.hp <= 0
  
      enemy.attack(user)
      break if user.hp <= 0
    end
    result(user: user,enemy: enemy)
  end

  # 戦闘結果
  def result(**params)
    user = params[:user]
    enemy = params[:enemy]

    battle_result = user.hp > 0
    if battle_result
      puts <<~EOS

      #{enemy.name}は倒れた。
      #{enemy.name}との戦闘に勝利した！
      Exp #{enemy.exp}
      Gold #{enemy.gold}
      を獲得した！

      EOS
    else
      puts <<~EOS

      #{user.name}は倒れた。
      #{enemy.name}との戦闘に敗北した...

      EOS
    end
    end
end