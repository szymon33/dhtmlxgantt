class AdminController < ApplicationController
  def index
  end

  def data
    tasks = Task.all
    links = GanttLink.all

    render :json => {
      data: tasks.map do |task|
      {
        id: task.id,
        text: task.text,
        start_date: task.start_date,
        duration: task.duration,
        progress: task.progress,
        parent: task.parent,
        sortorder: task.sortorder
      }
      end,
      links: links.map do |link|
      {
        id: link.id,
        source: link.source, 
        target: link.target, 
        type: link.gtype
      }  
      end
    }, status: :ok
  end  

  def db_action
    @gantt_mode = params['gantt_mode']
    @id = params['ids']
    @mode = params["#{@id}_!nativeeditor_status"]

    case @gantt_mode
    when "links"
      case @mode
      when "inserted"
          link = GanttLink.new
          # link.id = @id
          link_from_params(link, @id)
          link.save
          @tid = link.id

      when "deleted"
          GanttLink.find(@id).destroy
          @tid = @id

      when "updated"
          link = GanttLink.find(@id)
          link_from_params(link, @id)
          link.save
          @tid = @id
      end    

    when "tasks"
      case @mode
      when "inserted"
          task = Task.new
          # task.id = @id
          task_from_params(task, @id)
          task.save
          @tid = task.id

      when "deleted"
          Task.find(@id).destroy
          @tid = @id

      when "updated"
          task = Task.find(@id)
          task_from_params(task, @id)
          task.save
          @tid = @id
      end              
    end
  end

  private

  def task_from_params(task, id)
    task.text = params["#{id}_text"]
    task.start_date = params["#{id}_start_date"]
    task.duration = params["#{id}_duration"]
    task.progress = params["#{id}_progress"]
    task.sortorder = params["#{id}_sortorder"]
    task.parent = params["#{id}_parent"]
  end

  def link_from_params(link, id)
    link.source = params["#{id}_source"]
    link.target = params["#{id}_target"]
    link.gtype  = params["#{id}_type"]
  end
end


