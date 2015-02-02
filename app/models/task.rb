class Task < ActiveRecord::Base
  belongs_to :project

  scope :gantt_data, -> { where.not(start_date: nil, duration: nil).joins(:project) }
end
