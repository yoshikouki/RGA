require './app/controllers/message_dialog'

# ゲームに関するUser/ Enemyクラスの共通モジュール
module Character
  include MessageDialog
  attr_accessor :name, :hp
  attr_reader :str, :vit, :max_hp

  SPEACIAL_ATTACK_CONSTANT = 1.5

  def initialize(**params)
    @name = params[:name]
    @hp = params[:hp]
    @str = params[:str]
    @vit = params[:vit]
    @max_hp = @hp
  end

  def attack(target)
    attack_type = decision_attack_type
    damage = calculate_damage(target: target, attack_type: attack_type)
    cause_damage(target: target, damage: damage)

    # メッセージ
    attack_message(attack_type: attack_type, damage: damage)
    "#{@name}の攻撃！ #{damage}のダメージ！！"
  end

  def decision_attack_type
    attack_num = rand(4)
    if attack_num.zero?
      :special_attack
    else
      :normal_attack
    end
  end

  private

  # クリティカル時の攻撃力
  def calculate_special_attack
    (@str * SPEACIAL_ATTACK_CONSTANT).round
  end

  # ダメージ計算
  # params[:target, :attack_type]
  def calculate_damage(**params)
    target = params[:target]
    attack_type = params[:attack_type]

    damage = if attack_type == :special_attack
               calculate_special_attack - target.vit
             else
               @str - target.vit
             end

    damage.positive? ? damage : 0
  end

  # ダメージ値によってHPを処理
  # params[:target, :damage]
  def cause_damage(**params)
    target = params[:target]
    damage = params[:damage]

    target.hp -= damage
    target.hp = 0 if target.hp.negative?

    damage_message(target: target, damage: damage)
  end
end
