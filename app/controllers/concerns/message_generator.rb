require 'active_support/concern'
# View に表示するメッセージやHashを作る
module MessageGenerator
  extend ActiveSupport::Concern

  def output_battle_logs
    @battle_logs
  end

  def g_battle_logs
    @battle_logs = {
      battle_info:   {
        situation_info: {}
      },
      action_logs:   [],
      battle_result: {
        lv_upped: {}
      }
    }
  end

  def g_battle_info(battle_type: battle_type)
    @battle_logs[:battle_info] = {
      player_info:    @player.attributes.symbolize_keys,
      enemy_info:     @enemy.attributes.symbolize_keys,
      situation_info: {
        battle_type: battle_type
      }
    }
  end

  def g_act_log(index, attack_hash)
    @battle_logs[:action_logs] << {
      act_turn:          index,
      current_player_hp: @player.current_hp,
      current_enemy_hp:  @enemy.current_hp
    }.merge(attack_hash)
  end

  def g_battle_result
    @battle_logs[:battle_result] = {
      player_won:     player_won?,
      last_player_hp: @player.current_hp,
      last_enemy_hp:  @enemy.current_hp
    }.merge(g_result_name_list)
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
    @battle_logs[:battle_result].merge!({
      current_exp:  @player.exp,
      current_coin: @player.coin
    }.merge(reward, lv_info))
  end
end
