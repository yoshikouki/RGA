require './app/controllers/message_dialog'

# ゲームに関するUser/ Enemyクラスの共通モジュール
module Character
  include MessageDialog
  attr_accessor :name, :current_hp
  attr_reader :str, :vit, :hp

  CRITICAL_ATTACK_CONSTANT = 1.5

  def initialize(**params)
    super(params)
    params.each { |k, v| instance_variable_set "@#{k}", v }
    @current_hp = @hp
  end

  def attack(target)
    attack_type = decision_attack_type
    damage = calculate_damage(target: target, attack_type: attack_type)
    cause_damage(target: target, damage: damage)

    # メッセージ
    attack_message(attack_type: attack_type, damage: damage)
    "#{@name}の攻撃！ #{target.name}に#{damage}のダメージ！！"
  end

  # 25%の確率でクリティカルになる
  def decision_attack_type
    rand(4).zero? ? :critical_attack : :normal_attack
  end

  private

  # クリティカル時の攻撃力
  def calculate_critical_attack
    (@str * CRITICAL_ATTACK_CONSTANT).round
  end

  # ダメージ計算
  # params[:target, :attack_type]
  def calculate_damage(**params)
    target = params[:target]
    attack_type = params[:attack_type]

    damage = if attack_type == :critical_attack
               calculate_critical_attack - target.vit
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

    target.current_hp -= damage
    target.current_hp = 0 if target.current_hp.negative?

    damage_message(target: target, damage: damage)
  end
end
