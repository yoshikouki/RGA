class Skill < ApplicationRecord
  has_many :acquired_skills, dependent: :destroy
  has_many :skill_acquisition_conditions, dependent: :destroy
end
