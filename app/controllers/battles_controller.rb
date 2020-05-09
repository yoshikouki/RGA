require './app/controllers/message_dialog'
# Battles Controller
class BattlesController < ApplicationController
  include MessageDialog

  EXP_CONSTANT = 2
  GOLD_CONSTANT = 3

  def index
    @player = Player.new(name: 'マダオ', hp: 50, str: 200, vit: 10)
    @enemy = Player.new(name: 'スライム', hp: 600, str: 20, vit: 100)
    battle(player: @player, enemy: @enemy)
  end

  # 戦闘イベント
  # 交互に攻撃し合う
  def battle(**params)
    @battle_logs = {}
    prepare_battle(params)
    battle_action(params)
    battle_judgement
    @battle_logs
  end

  private

  def prepare_battle(**params)
    @player = params[:player]
    @enemy = params[:enemy]
  end

  def battle_action(_params)
    logs = []
    1.step do |i|
      log = i.odd? ? @player.attack(@enemy) : @enemy.attack(@player)
      log[:status_log] = { player_current_hp: @player.current_hp,
                           enemy_current_hp:  @enemy.current_hp }
      logs << { battle_turn: i,
                turn_log:    {
                  attack_log: log[:attack_log].join(' '),
                  damage_log: log[:damage_log].join(' '),
                  status_log: log[:status_log]
                } }
      break if battle_end?
    end
    @battle_logs[:action] = logs
  end

  # 戦闘終了フラグ
  def battle_end?
    @player.current_hp <= 0 || @enemy.current_hp <= 0
  end

  # 戦闘結果
  def battle_judgement
    if user_won?
      reward = calculate_battle_reward
      user_won_message(reward: reward)
    else
      user_lost_message
    end
  end

  # 戦闘結果の判定
  def user_won?
    @player.current_hp.positive?
  end

  # 戦闘報酬の計算
  def calculate_battle_reward
    exp = (@enemy.str + @enemy.vit) * EXP_CONSTANT
    gold = @enemy.hp * GOLD_CONSTANT
    { exp: exp, gold: gold }
  end
end
