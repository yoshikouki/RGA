require './app/models/character'

class User < Character

  def attack(target)
    attack_type = decision_attack_type
    damage = calculate_damage(target: target, attack_type: attack_type)
    cause_damage(target: target, damage: damage)

    puts <<~EOS
    #{target.name} HP: #{target.hp} 
    EOS
  end

    def decision_attack_type
      attack_num = rand(4)
      if attack_num == 0
        puts "#{@name}の必殺技！"
        :special_attack
      else
        puts "#{@name}の通常攻撃！"
        :normal_attack
      end
    end
end
