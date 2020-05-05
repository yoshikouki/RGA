require './app/models/character'

class Enemy < Character
  attr_accessor :transformed
  attr_reader :exp, :gold

  EXP_CONSTANT = 2
  GOLD_CONSTANT = 3

  def initialize(**params)
    super
    @transformed = false
    @exp = (@str + @vit) * EXP_CONSTANT
    @gold = (@max_hp) * GOLD_CONSTANT
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
end
