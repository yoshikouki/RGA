# 全てのModelに継承されるModel
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
