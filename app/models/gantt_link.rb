class GanttLink < ActiveRecord::Base
  belongs_to :project  
  belongs_to :targetable, polymorphic: true
  belongs_to :sourceable, polymorphic: true

  validates_presence_of :project
  validates_presence_of :targetable
  validates_presence_of :sourceable
end
