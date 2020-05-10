# Battles Controller
class BattlesController < ApplicationController

  EXP_CONSTANT = 2
  COIN_CONSTANT = 3

  def index
    @player = Player.new(name: 'マダオ', hp: 50, str: 200, vit: 10)
    @enemy = Player.new(name: 'スライム', hp: 600, str: 20, vit: 100)
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
    @battle_logs
  end

  private

  def prepare_battle(**params)
    params.each { |k, v| instance_variable_set "@#{k}", v }
    # 戻り値 :battle_info
    { player_info:    { name: @player.name,
                        lv:   @player.lv,
                        hp:   @player.hp,
                        str:  @player.str,
                        vit:  @player.vit },
      enemy_info:     { name: @enemy.name,
                        lv:   @enemy.lv,
                        hp:   @enemy.hp,
                        str:  @enemy.str,
                        vit:  @enemy.vit },
      situation_info: { battle_type: :normal_battle } }
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
    h = if user_won?
          reward = calculate_battle_reward
          { player_won:  true,
            winner_name: @player.name,
            loser_name:  @enemy.name,
            get_exp:     reward[:get_exp],
            get_coin:    reward[:get_coin] }
        else
          { player_won:  false,
            winner_name: @enemy.name,
            loser_name:  @player.name }
        end
    { last_player_hp: @player.current_hp,
      last_enemy_hp:  @enemy.current_hp }
      .merge(h)
  end

  # 戦闘結果の判定
  def user_won?
    @player.current_hp.positive?
  end

  # 戦闘報酬の計算
  def calculate_battle_reward
    exp = (@enemy.str + @enemy.vit) * EXP_CONSTANT
    coin = @enemy.hp * COIN_CONSTANT
    { get_exp:  exp,
      get_coin: coin }
  end
end
