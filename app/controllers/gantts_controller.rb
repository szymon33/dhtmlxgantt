class GanttsController < ApplicationController

  def index
  end


  def data
    # you can simple limit chart to your one project like this
    # tasks = Task.gantt_data.where(project_id: your_project)
    tasks    = Task.gantt_data
    projects = tasks.select("projects.id, projects.name").uniq
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
          parent: "projects-#{task.parent}",
          type: 'task'
        }
      end,

      links: links.map do |link|
      {
        id: link.id,
        source: "#{link.sourceable_type.to_s.pluralize.downcase}-#{link.sourceable.id}", 
        target: "#{link.targetable_type.to_s.pluralize.downcase}-#{link.targetable.id}", 
        type: link.gtype
      }  
      end
    }, status: :ok
  end  


  def db_action
    params['ids'].split(',').each do |id|
      @id   = id
      @mode = params["#{@id}_!nativeeditor_status"]          
      db_id = @id.split('-')[1].to_i unless @mode=='inserted'      

      # project looks like a task but we need the project to be the project
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
            task.save!
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
            link.save!
            @tid = link.id

        when "deleted"
            link = GanttLink.find(@id)                  
            @tid = link.destroy.id

        when "updated"
            link = GanttLink.find(@id)
            link_from_params(link, @id)
            link.save!
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
            project.save!
            @tid = project.id
        end              
      end
    end
  end

  private

  def project_from_params(project, id)
    project.name    = params["#{id}_text"].to_s
  end
  
  def task_from_params(task, id)
    task.name       = params["#{id}_text"].to_s
    task.start_date = params["#{id}_start_date"].to_date
    task.duration   = params["#{id}_duration"].to_i
    task.progress   = params["#{id}_progress"].to_f
    task.parent     = params["#{id}_parent"].split('-')[1].to_i  
    task.project_id = task.parent # this is limitation
  end

  def link_from_params(link, id)  
    source_type = params["#{id}_source"].split('-')[0].classify.constantize
    source_id   = params["#{id}_source"].split('-')[1].to_i

    destination_type = params["#{id}_target"].split('-')[0].classify.constantize
    destination_id   = params["#{id}_target"].split('-')[1].to_i

    link.sourceable = source_type.find(source_id)
    link.targetable = destination_type.find(destination_id)
    link.gtype      = params["#{id}_type"]
    # inherit project scope
    link.project_id = link.targetable.instance_of?(Project) ? link.targetable.id : link.targetable.project_id 
  end
end
