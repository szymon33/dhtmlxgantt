class GanttLink < ActiveRecord::Base
  belongs_to :project  
  belongs_to :sourceable, polymorphic: true  
  belongs_to :targetable, polymorphic: true

  validates_presence_of :project
  validates_presence_of :targetable
  validates_presence_of :sourceable

  def from_params(params, session, id)
    source_addr = params["#{id}_source"]
    source = if (temp = session["custom-#{source_addr}"])
      temp['type'] + "-" + temp['id'].to_s
    else
      source_addr
    end

    source_type = source.split('-')[0].classify.constantize
    source_id   = source.split('-')[1].to_i

    target_addr = params["#{id}_target"]
    target = if (temp=session["custom-#{target_addr}"])
      temp['type'] + "-" + temp['id'].to_s
    else
      target_addr
    end

    target_type = target.split('-')[0].classify.constantize
    target_id   = target.split('-')[1].to_i


    self.sourceable = source_type.find(source_id)
    self.targetable = target_type.find(target_id)
    self.gtype      = params["#{id}_type"]
    # inherit project scope
    self.project_id = self.targetable.instance_of?(Project) ? self.targetable.id : self.targetable.project_id 
  end  
end
