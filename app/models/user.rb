require './app/models/character'

class User < Character

  def attack(target)
    attack_type = decision_attack_type
    attack_message(attack_type: attack_type)

    damage = calculate_damage(target: target, attack_type: attack_type)
    cause_damage(target: target, damage: damage)
  end

    def decision_attack_type
      attack_num = rand(4)
      if attack_num == 0
        :special_attack
      else
        :normal_attack
      end
    end
end
