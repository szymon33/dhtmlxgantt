class Task < ActiveRecord::Base
  belongs_to :project
  has_many :sources, as: :sourceable 
  has_many :targets, as: :targetable

  # Below Rails 4
  # scope :gantt_data, where("start_date IS NOT NULL AND duration IS NOT NULL").joins(:project)
  # Rails 4 and above
  scope :gantt_data, -> { where.not(start_date: nil, duration: nil).joins(:project) }
end
