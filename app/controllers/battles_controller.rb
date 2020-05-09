require './app/controllers/message_dialog'
# Battles Controller
class BattlesController < ApplicationController
  include MessageDialog

  EXP_CONSTANT = 2
  GOLD_CONSTANT = 3

  def index
    brave_params = { name: 'テリー', hp: 500, str: 200, vit: 100 }
    enemy_params = { name: 'スライム', hp: 600, str: 200, vit: 100 }
    @player = Player.new(brave_params)
    @enemy = Player.new(enemy_params)

    matching = { player: @player, enemy: @enemy }
    @logs = battle(matching)
  end

  # 戦闘イベント
  # 交互に攻撃し合う
  def battle(**params)
    get_character(params)

    @battle_logs = []
    loop do
      @battle_logs << @player.attack(@enemy)
      break if battle_end?

      @battle_logs << @enemy.attack(@player)
      break if battle_end?
    end

    battle_judgement
    @battle_logs
  end

  private

  def get_character(**params)
    @player = params[:player]
    @enemy = params[:enemy]
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
