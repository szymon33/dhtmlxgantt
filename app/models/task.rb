class Task < ActiveRecord::Base
  belongs_to :project

  scope :gantt_valid, -> { where.not(start_date: nil, duration: nil) }
end
