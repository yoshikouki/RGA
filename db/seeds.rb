# Jobs マスタ
require 'csv'
jobs = []
CSV.foreach('db/data/jobs_master_data.csv', headers: true) do |row|
  params = row.to_h.transform_keys(&:to_s)
  jobs << Job.create(params)
end

# ユーザー
User.create!(username:              'Game Master',
             email:                 'yoshikouki@gmail.com',
             password:              'password',
             password_confirmation: 'password',
             confirmed_at:          Time.zone.now)
