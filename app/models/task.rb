class Task < ActiveRecord::Base
  include Gantable

  belongs_to :project

  # Below Rails 4
  # scope :gantt_data, where("start_date IS NOT NULL AND duration IS NOT NULL").joins(:project)
  # Rails 4 and above
  scope :gantt_data, -> { where.not(start_date: nil, duration: nil).order(:sortorder).joins(:project) }

  def reorder(target)
    source_row = self
    target_row = Task.find(target)
    from = Task.gantt_data.index(source_row)
    to   = Task.gantt_data.index(target_row)
    if from < to
      effected = Task.gantt_data[from..to]
    else
      effected = Task.gantt_data[to..from]
    end
  end

  def from_params(params, id)
    self.name       = params["#{id}_text"].to_s
    self.start_date = params["#{id}_start_date"].to_date
    self.duration   = params["#{id}_duration"].to_i
    self.progress   = params["#{id}_progress"].to_f
    self.parent     = params["#{id}_parent"].split('-')[1].to_i  
    self.project_id = self.parent # this is limitation
  end
end
