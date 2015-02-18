class Project < ActiveRecord::Base
  has_many :tasks
  has_many :sources, as: :sourceable, class_name: 'GanttLink'
  has_many :targets, as: :targetable, class_name: 'GanttLink'
  has_many :ganttlinks 

  before_destroy :destroy_gantt_links  

  private

  def destroy_gantt_links
    self.sources.destroy_all
    self.targets.destroy_all
  end  
end
