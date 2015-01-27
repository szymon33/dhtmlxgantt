class GanttLink < ActiveRecord::Base
  belongs_to :target, class_name: "Task"
  belongs_to :source, class_name: "Task"

  validates_presence_of :target
  validates_presence_of :source
end
