# ゲーム用ユーザーデータ
class Player < ApplicationRecord
  include Character
  include LevelUp
  include JobChange

  belongs_to :user
  has_many :job_levels, dependent: :destroy
  has_many :acquired_skills, dependent: :destroy

  # new, create, find(インスタンス化) 後に実行
  after_initialize :set_params
  after_create :to_create_job_level

  attr_accessor :lv_up_diff,
                :next_lv_exp

  with_options presence: true do
    with_options numericality: { only_integer: true } do
      validates :lv
      validates :exp
      validates :hp
      validates :str
      validates :vit
      validates :coin
      validates :current_job_id
    end
    with_options uniqueness: { case_sensitive: false } do
      validates :user_id
      validates :name, length: { maximum: 50 }
    end
  end

  # #new でステータスが nil の場合は初期値で上書き
  def initialize(params)
    params = params ? params.reverse_merge(INIT_PARAMS) : INIT_PARAMS
    super(params)
  end

  # インスタンス化するたびにパラメータを設定
  def set_params
    self.current_hp = hp
    self.next_lv_exp = calculate_exp_to_lv_up(lv + 1) - exp
  end

  private

  def to_create_job_level
    job_levels.create
  end

  INIT_PARAMS = {
    name:           'init_player',
    lv:             1,
    exp:            0,
    hp:             100,
    str:            10,
    vit:            10,
    coin:           0,
    current_job_id: 1,
    lv_up_diff:     0
  }.freeze
end
