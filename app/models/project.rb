class Project < ActiveRecord::Base
  include Gantable

  has_many :tasks
  has_many :ganttlinks 

  def from_params(params, id)
    self.name = params["#{id}_text"].to_s
  end  
end
