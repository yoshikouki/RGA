require 'active_support/concern'
# View に表示するメッセージやHashを作る
module MessageGenerator
  extend ActiveSupport::Concern

  included do
    @msg = {}
  end

  def g_battle_info(battle_type: battle_type)
    {
      player_info:    @player,
      enemy_info:     @enemy,
      situation_info: {
        battle_type: battle_type
      }
    }
  end

  def g_battle_result(name_list: names)
    {
      player_won:     player_won?,
      last_player_hp: @player.current_hp,
      last_enemy_hp:  @enemy.current_hp
    }.merge(name_list)
  end

  def g_result_name_list
    if player_won?
      { winner_name: @player.name,
        loser_name:  @enemy.name }
    else
      { winner_name: @enemy.name,
        loser_name:  @player.name }
    end
  end

  def g_reward_list(reward, lv_info)
    {
      current_exp:  @player.exp,
      current_coin: @player.coin
    }.merge(reward, lv_info)
  end

  def g_get_reward(get_exp: exp, get_coin: coin)
    { get_exp:  get_exp,
      get_coin: get_coin }
  end
end