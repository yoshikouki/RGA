# ホームやライセンスなどの静的なページへのコントローラー
class PagesController < ApplicationController
  # before_action :sign_in_required, only: [:index]

  def home
    brave_params = { name: "テリー",hp: 500, str: 150, vit: 100 }
    enemy_params = { name: "スライム", hp: 250, str: 200, vit: 100 }
    @user = User.new(brave_params)
    @enemy = User.new(enemy_params)

    battles_controller = BattlesController.new
    matching = { user: @user, enemy: @enemy }
    @battle = battles_controller.battle(matching)
  end
end
