class Task < ActiveRecord::Base
  belongs_to :project
  after_initialize :defaults # just in case

  private
  
  def defaults
    self.start_date ||= Date.today
    self.duration   ||= 1
  end
end
