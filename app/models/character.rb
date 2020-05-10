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
    critical_hit = critical_hit?
    attack_type = :normal_attack
    damage = calculate_damage(target: target, critical_hit: critical_hit)
    cause_damage(target: target, damage: damage)

    #  戻り値 :action_logs配列アイテムの一部
    { actor_name:        @name,
      target_name:       target.name,
      act_type:          attack_type,
      critical_hit:      critical_hit,
      damage:            damage,
      current_target_hp: target.current_hp }
  end

  # 25%の確率でクリティカルになる
  def critical_hit?
    rand(4).zero?
  end

  private

  # ダメージ計算
  # params[:target, :attack_type]
  def calculate_damage(**params)
    target = params[:target]
    critical_hit = params[:critical_hit]
    atk = critical_hit ? calculate_critical_attack : @str
    damage = damage_range(atk) - target.vit
    damage.positive? ? damage : 0
  end

  # クリティカル時の攻撃力
  def calculate_critical_attack
    (@str * CRITICAL_ATTACK_CONSTANT).round
  end

  # ダメージの振れ幅を計算する
  def damage_range(atk)
    (atk * rand(0.85...1.1)).round
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
