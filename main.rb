SPEACIAL_ATTACK_CONSTANT = 1.5

class Character
  attr_reader :str, :vit, :max_hp
  attr_accessor :name, :hp

  def initialize(**params)
    @name = params[:name]
    @hp = params[:hp]
    @str = params[:str]
    @vit = params[:vit]
    @max_hp = @hp
  end
end

class User < Character
  def attack(target)
    attack_type = decision_attack_type
    damage = calculate_damage(target: target, attack_type: attack_type)
    cause_damage(target: target, damage: damage)

    puts <<~EOS
    #{target.name} HP: #{target.hp} 
    EOS
  end

  private

    def calculate_special_attack
      (@str * SPEACIAL_ATTACK_CONSTANT).round
    end

    def decision_attack_type
      attack_num = rand(4)
      if attack_num == 0
        puts "#{@name}の必殺技！"
        :special_attack
      else
        puts "#{@name}の通常攻撃！"
        :normal_attack
      end
    end

    def calculate_damage(**params)
      if params[:attack_type] == :special_attack
        calculate_special_attack - params[:target].vit
      else
        @str - params[:target].vit
      end
    end

    def cause_damage(**params)
      target = params[:target]
      damage = params[:damage]
      target.hp -= damage
      target.hp = 0 if target.hp < 0

      puts <<~EOS
      #{target.name}に #{damage}のダメージ！
      EOS
    end
end



class Enemy < Character
  attr_accessor :transformed

  def initialize(**params)
    super
    @transformed = false
  end

  def attack(target)
    transform

    puts "#{@name}の攻撃！"
    damage = calculate_damage(target: target)
    cause_damage(target: target, damage: damage)

    puts <<~EOS
    #{target.name} HP: #{target.hp} 
    EOS
  end

  private
    # クリティカル時の攻撃力
    def calculate_special_attack
      (@str * SPEACIAL_ATTACK_CONSTANT).round
    end

    # 変身メソッド
    def transform
      return false unless @hp <= @max_hp * 0.5 && !@transformed

      init_name = @name
      @name = "ドラゴン"
      @str = calculate_special_attack
      @transformed = true

      puts <<~EOS
      #{init_name}は怒っている
      #{init_name}は#{@name}に変身した
      EOS
    end

    def calculate_damage(**params)
      damage = @str - params[:target].vit
      damage > 0 ? damage : 0
    end

    def cause_damage(**params)
      target = params[:target]
      damage = params[:damage]
      target.hp -= damage
      target.hp = 0 if target.hp < 0

      puts <<~EOS
      #{target.name}に #{damage}のダメージ！
      EOS
    end
end



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
