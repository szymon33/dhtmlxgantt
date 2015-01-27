class AdminController < ApplicationController
  def index
  end

  def data
    tasks = Task.all
    links = GanttLink.all
    projects = Project.all

    render :json => {
      data: (projects.map do |project| 
        {
          id: "project-#{project.id}",
          text: project.text,
          type: 'project',
          open: true
        }
      end) + tasks.map do |task|
        {
          id: "task-#{task.id}",
          text: task.text,
          start_date: task.start_date,
          duration: task.duration,
          progress: task.progress,
          parent: "project-#{task.project_id}",
          type: 'task'
        }
      end,

      links: links.map do |link|
      {
        id: link.id,
        source: "task-#{link.source_id}", 
        target: "task-#{link.target_id}", 
        type: link.gtype
      }  
      end
    }, status: :ok
  end  

  def db_action
    @gantt_mode = params['gantt_mode']
    @id = params['ids']
    db_id = @id.scan(/\d/).join('')
    @mode = params["#{@id}_!nativeeditor_status"]

    case @gantt_mode
    when "tasks"
      case @mode
      when "inserted"
          task = Task.new
          # task.id = @id
          task_from_params(task, @id)
          task.save
          @tid = task.id

      when "deleted"
          task = Task.find(db_id)
          task.destroy
          @tid = task.id

      when "updated"
          task = Task.find(db_id)
          task_from_params(task, @id)
          task.save
          @tid = db_id

      when "order"
      end              


    when "links"
      case @mode
      when "inserted"
          link = GanttLink.new
          # link.id = @id
          link_from_params(link, @id)
          link.save
          @tid = link.id

      when "deleted"
          link = GanttLink.find(@id)        
          link.destroy
          @tid = link.id

      when "updated"
          link = GanttLink.find(@id)
          link_from_params(link, @id)
          link.save
          @tid = link.id
      end        


    when "projects"
    end
  end

  private

  def task_from_params(task, id)
    task.text       = params["#{id}_text"]
    task.start_date = params["#{id}_start_date"]
    task.duration   = params["#{id}_duration"]
    task.progress   = params["#{id}_progress"]
    task.project_id = params["#{id}_parent"].scan(/\d/).join('').to_i
  end

  def link_from_params(link, id)    
    link.source_id = params["#{id}_source"].scan(/\d/).join('').to_i
    link.target_id = params["#{id}_target"].scan(/\d/).join('').to_i
    link.gtype  = params["#{id}_type"]
  end
end
