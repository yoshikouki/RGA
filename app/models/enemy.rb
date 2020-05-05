require './app/models/character'

class Enemy < Character
  attr_accessor :transformed

  def initialize(**params)
    super
    @transformed = false
  end

  def attack(target)
    transform

    attack_message
    damage = calculate_damage(target: target)
    cause_damage(target: target, damage: damage)
  end

  private

    # 変身メソッド
    def transform
      return false unless @hp <= @max_hp * 0.5 && !@transformed

      init_name = @name
      @name = "ドラゴン"
      @str = calculate_special_attack
      @transformed = true

      enemy_transform_message({ before_name: init_name, after_name:@name })
    end
end
