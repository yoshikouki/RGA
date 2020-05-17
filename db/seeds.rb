# Jobs マスタ
require 'csv'
jobs = []
CSV.foreach('db/data/jobs_master_data.csv', headers: true) do |row|
  params = row.to_h.transform_keys(&:to_s)
  jobs << Job.build(params)
end
jobs.save

# ユーザー
User.create!(username:              'Game Master',
             email:                 'yoshikouki@gmail.com',
             password:              'password',
             password_confirmation: 'password',
             confirmation_at:       Time.zone.now)
