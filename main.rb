require './app/models/user'
require './app/models/enemy'

SPEACIAL_ATTACK_CONSTANT = 1.5

brave_params = { name: "テリー",hp: 500, str: 150, vit: 100 }
brave = User.new(brave_params)

slime_params = { name: "スライム", hp: 250, str: 200, vit: 100 }
slime = Enemy.new(slime_params)

# 戦闘イベント
# 交互に攻撃し合う
loop do
  brave.attack(slime)
  break if slime.hp <= 0

  slime.attack(brave)
  break if brave.hp <= 0
end

# 戦闘結果
battle_result = brave.hp > 0
if battle_result
  exp = (slime.str + slime.vit) * 2
  gold = (slime.max_hp) * 3
  puts <<~EOS

  #{slime.name}は倒れた。
  #{slime.name}との戦闘に勝利した！
  Exp #{exp}
  Gold #{gold}
  を獲得した！

  EOS
else
  puts <<~EOS

  #{brave.name}は倒れた。
  #{slime.name}との戦闘に敗北した...

  EOS
end
