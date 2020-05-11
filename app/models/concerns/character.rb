require 'active_support/concern'
# ゲームに関するUser/ Enemyクラスの共通モジュール
module Character
  extend ActiveSupport::Concern

  attr_accessor :name, :str, :vit, :hp, :current_hp

  CRITICAL_ATTACK_CONSTANT = 1.5

  def initialize(**params)
    super(params)
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

  private

  # 25%の確率でクリティカルになる
  def critical_hit?
    rand(4).zero?
  end

  # ダメージ計算
  # params[:target, :attack_type]
  def calculate_damage(**params)
    atk = params[:critical_hit] ? calculate_critical_attack : @str
    damage = damage_range(atk) - params[:target].vit
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
    target.current_hp -= params[:damage]
    target.current_hp = 0 if target.current_hp.negative?
  end
end
