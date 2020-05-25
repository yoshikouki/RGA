require 'csv'
# Jobs マスタ
CSV.foreach('db/data/jobs_master_data.csv', headers: true) do |row|
  params = row.to_h.transform_keys(&:to_s)
  Job.create(params)
end

# JobChangeConditions マスタ
CSV.foreach('db/data/job_change_conditions_master_data.csv', headers: true) do |row|
  params = row.to_h.transform_keys(&:to_s)
  JobChangeCondition.create(params)
end

# Skills マスタ
CSV.foreach('db/data/skills_master_data.csv', headers: true) do |row|
  params = row.to_h.transform_keys(&:to_s)
  Skill.create(params)
end

# SkillAcquisitionConditions マスタ
CSV.foreach('db/data/skill_acquisition_conditions_master_data.csv', headers: true) do |row|
  params = row.to_h.transform_keys(&:to_s)
  SkillAcquisitionCondition.create(params)
end

# ユーザー
User.create!(username:              'Game Master',
             email:                 'yoshikouki@gmail.com',
             password:              'password',
             password_confirmation: 'password',
             confirmed_at:          Time.zone.now)
