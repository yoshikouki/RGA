require './app/controllers/battles_controller'
require './app/models/user'
require './app/models/enemy'

battles_controller = BattlesController.new

brave_params = { name: "テリー",hp: 500, str: 150, vit: 100 }
brave = User.new(brave_params)

slime_params = { name: "スライム", hp: 250, str: 200, vit: 100 }
slime = Enemy.new(slime_params)

matching = { user: brave, enemy: slime }
battles_controller.battle(matching)
