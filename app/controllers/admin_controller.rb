class AdminController < ApplicationController
  def index
  end

  def data
    # you can simple limit chart to your one project like this
    # tasks = Task.gantt_data.where(project_id: your_project)
    tasks    = Task.gantt_data
    projects = tasks.select("projects.id","projects.name").uniq
    links    = GanttLink.all

    render json: {
      data: (projects.map do |project| 
        {
          id: "projects-#{project.id}",
          text: project.name,
          type: 'project',
          open: true
        }
      end) + tasks.map do |task|
        {
          id: "tasks-#{task.id}",
          text: task.name,
          start_date: task.start_date,
          duration: task.duration,
          progress: task.progress,
          parent: "projects-#{task.project_id}",
          type: 'task'
        }
      end,

      links: links.map do |link|
      {
        id: link.id,
        source: "tasks-#{link.source_id}", 
        target: "tasks-#{link.target_id}", 
        type: link.gtype
      }  
      end
    }, status: :ok
  end  

  def db_action
    params['ids'].split(',').each do |id|
      @id = id
      db_id = @id.scan(/\d/).join('') unless @mode=='inserted'      
      @mode = params["#{@id}_!nativeeditor_status"]    

      # project is a task but we need the project to be the project
      @gantt_mode = if params['gantt_mode'] == 'tasks' and not @mode=='inserted' then
        @id.split('-')[0] 
      else
        params['gantt_mode']
      end

      case @gantt_mode
      when "tasks"
        case @mode
        when "inserted"
            task = Task.new
            task_from_params(task, @id)
            task.save
            @tid = task.id

        when "deleted"
            task = Task.find(db_id)
            @tid = task.destroy.id

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
            link_from_params(link, @id)
            link.save
            @tid = link.id

        when "deleted"
            link = GanttLink.find(@id)                  
            @tid = link.destroy.id

        when "updated"
            link = GanttLink.find(@id)
            link_from_params(link, @id)
            link.save
            @tid = link.id
        end        


      when "projects"
        case @mode
        when "deleted"
            project = Project.find(db_id)                  
            @tid = project.destroy.id

        when "updated"
            project = Project.find(db_id)
            project_from_params(project, @id)
            project.save
            @tid = project.id
        end              
      end
    end
  end

  private

  def task_from_params(task, id)
    task.name       = params["#{id}_text"]
    task.start_date = params["#{id}_start_date"]
    task.duration   = params["#{id}_duration"]
    task.progress   = params["#{id}_progress"]
    task.project_id = params["#{id}_parent"].scan(/\d/).join('').to_i
  end

  def link_from_params(link, id)    
    link.source_id  = params["#{id}_source"].scan(/\d/).join('').to_i
    link.target_id  = params["#{id}_target"].scan(/\d/).join('').to_i
    link.gtype      = params["#{id}_type"]
  end

  def project_from_params(project, id)
    project.name    = params["#{id}_text"]
  end

end
