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

  def g_battle_info(battle_type)
    @battle_logs[:battle_info] = {
      begin_player:   @player.attributes.symbolize_keys,
      begin_enemy:    @enemy.attributes.symbolize_keys,
      situation_info: {
        battle_type: battle_type
      }
    }
  end

  def g_attack_hash(character, target, attack_type, critical_hit, damage)
    { actor_name:   character.name,
      target_name:  target.name,
      act_type:     attack_type,
      critical_hit: critical_hit,
      damage:       damage }
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

  def g_reward_info(reward, lv_up_diff)
    @battle_logs[:battle_result]
      .merge!({ get_exp:         reward[:get_exp],
                get_coin:        reward[:get_coin],
                end_player_info: @player.attributes.symbolize_keys,
                lv_upped:        lv_up_diff })
  end
end
