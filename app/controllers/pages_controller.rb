# ホームやライセンスなどの静的なページへのコントローラー
class PagesController < ApplicationController
  before_action :sign_in_required, except: [:introduction]

  def home; end

  def introduction; end
end
