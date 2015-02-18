class Task < ActiveRecord::Base
  belongs_to :project
  has_many :sources, as: :sourceable, class_name: 'GanttLink'
  has_many :targets, as: :targetable, class_name: 'GanttLink'

  before_destroy :destroy_gantt_links  

  # Below Rails 4
  # scope :gantt_data, where("start_date IS NOT NULL AND duration IS NOT NULL").joins(:project)
  # Rails 4 and above
  scope :gantt_data, -> { where.not(start_date: nil, duration: nil).joins(:project) }

  private

  def destroy_gantt_links
    self.sources.destroy_all
    self.targets.destroy_all
  end  
end
