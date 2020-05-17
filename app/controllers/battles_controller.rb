# Battles Controller
class BattlesController < ApplicationController
  EXP_CONSTANT = 2
  COIN_CONSTANT = 3
  include MessageGenerator
  before_action :sign_in_required

  def index
    @player = current_user.player
    enemy_params = { name: 'マダオ',
                     hp:   @player.hp,
                     str:  @player.str,
                     vit:  @player.vit * 0.5 }
    @enemy = Player.new(enemy_params)
    battle(player: @player, enemy: @enemy)
  end

  # 戦闘イベント
  # 交互に攻撃し合う
  def battle(**params)
    return false unless params[:player].valid? || params[:enemy].valid?

    prepare_battle(params)
    battle_action
    battle_judgement
    apply_result if player_won?
    output_battle_logs
  end

  private

  def prepare_battle(**params)
    params.each { |k, v| instance_variable_set "@#{k}", v }
    g_battle_logs
    g_battle_info(battle_type: :normal_battle)
  end

  def battle_action
    1.step do |i|
      attack_hash = i.odd? ? @player.attack(@enemy) : @enemy.attack(@player)
      g_act_log(i, attack_hash)
      break if battle_end?
    end
  end

  # 戦闘終了フラグ
  def battle_end?
    @player.current_hp <= 0 || @enemy.current_hp <= 0
  end

  # 戦闘結果
  def battle_judgement
    g_battle_result
  end

  # 戦闘結果の判定
  def player_won?
    @player.current_hp.positive?
  end

  def apply_result
    reward = calculate_battle_reward
    @player
      .earn_reward(reward)
      .decision_lv_up
    @player
      .current_job
      .earn_reward(reward)
      .decision_level_up
    g_reward_info(reward)
  end

  # 戦闘報酬の計算
  def calculate_battle_reward
    exp = (@enemy.str + @enemy.vit) * EXP_CONSTANT
    coin = @enemy.hp * COIN_CONSTANT
    { get_exp:  exp,
      get_coin: coin }
  end
end
