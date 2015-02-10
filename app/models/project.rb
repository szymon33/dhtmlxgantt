class Project < ActiveRecord::Base
  has_many :tasks
  has_many :sources, as: :sourceable
  has_many :targets, as: :targetable  
end
