module Gantable
  def self.included(base)
    base.extend(ClassMethods)
    base.class_eval do
      has_many :sources, as: :sourceable, class_name: 'GanttLink'
      has_many :targets, as: :targetable, class_name: 'GanttLink'

      before_destroy :destroy_gantt_links  
    end
  end

  def destroy_gantt_links
    self.sources.destroy_all
    self.targets.destroy_all
  end  

  module ClassMethods
  end
end
