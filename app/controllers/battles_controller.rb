# Battles Controller
class BattlesController < ApplicationController
  EXP_CONSTANT = 2
  COIN_CONSTANT = 3
  include MessageGenerator

  def index
    @player = Player.find(1)
    # @enemy = Player.find(2)
    @enemy = Player.new(name: 'マダオ', hp: 50, str: 20, vit: 5)
    battle(player: @player, enemy: @enemy)
  end

  # 戦闘イベント
  # 交互に攻撃し合う
  def battle(**params)
    return false unless params[:player].valid? || params[:enemy].valid?

    @battle_logs = {}
    @battle_logs[:battle_info] = prepare_battle(params)
    @battle_logs[:action_logs] = battle_action(params)
    @battle_logs[:battle_result] = battle_judgement
    if player_won?
      reward_result = apply_result
      @battle_logs[:battle_result].merge!(reward_result)
    end
    @battle_logs
  end

  private

  def prepare_battle(**params)
    params.each { |k, v| instance_variable_set "@#{k}", v }
    # 戻り値 :battle_info
    g_battle_info(battle_type: :normal_battle)
  end

  def battle_action(_params)
    action_logs = []
    1.step do |i|
      attack_hash = i.odd? ? @player.attack(@enemy) : @enemy.attack(@player)
      action_logs << { act_turn:          i,
                       current_player_hp: @player.current_hp,
                       current_enemy_hp:  @enemy.current_hp }
                     .merge(attack_hash)
      break if battle_end?
    end
    action_logs
  end

  # 戦闘終了フラグ
  def battle_end?
    @player.current_hp <= 0 || @enemy.current_hp <= 0
  end

  # 戦闘結果
  def battle_judgement
    player_won?
    names = result_name_list
    g_battle_result(name_list: names)
  end

  # 戦闘結果の判定
  def player_won?
    @player.current_hp.positive?
  end

  # 勝者と敗者の名前を変数定義
  def result_name_list
    g_result_name_list
  end

  def apply_result
    reward = calculate_battle_reward
    @player = @player.earn_reward(reward)
    lv_info = @player.decision_level_up
    g_reward_list(reward, lv_info)
  end

  # 戦闘報酬の計算
  def calculate_battle_reward
    exp = (@enemy.str + @enemy.vit) * EXP_CONSTANT
    coin = @enemy.hp * COIN_CONSTANT
    g_get_reward(get_exp: exp, get_coin: coin)
  end

  # 報酬が両方0ならtrue
  def reward_none?(**params)
    params[:get_exp].zero? && params[:get_coin].zero?
  end
end
