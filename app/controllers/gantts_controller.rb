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
          sortorder: task.sortorder,
          parent: "projects-#{task.project_id}",
          type: 'task'
        }
      end,

      links: links.map do |link|
      {
        id: "links-#{link.id}",
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
      # project looks like a task but we need the project to be the project
      if session["custom-#{id}"]
        @gantt_mode = session["custom-#{id}"]['type'] 
        db_id = session["custom-#{id}"]['id']
      else
        # project update and delete look like a task but we need the project to be the project
        @gantt_mode = if @mode=='inserted' then params['gantt_mode'] else @id.split('-')[0] end
        db_id = @id.split('-')[1].to_i
      end

      case @gantt_mode
      when "tasks"
        case @mode
        when "inserted"
            task = Task.new
            task_from_params(task, @id)            
            if task.save
              session["custom-#{@id}"] = { id: task.id, type: @gantt_mode }
              @tid = @id
            end

        when "deleted"
            task = Task.find(db_id)
            task.destroy
            @tid= @id

        when "updated"
            task = Task.find(db_id)
            task_from_params(task, @id)            
            if task.save
              @tid = @id
            end

        when "order"

        end              


      when "links"
        case @mode
        when "inserted"
            link = GanttLink.new
            link_from_params(link, @id)
            if link.save
              session["custom-#{@id}"] = { id: link.id, type: @gantt_mode }
              @tid = @id
            end

        when "deleted"
            link = GanttLink.find(db_id)
            link.destroy
            @tid = @id           

        when "updated"
            link = GanttLink.find(db_id)
            link_from_params(link, @id)
            if link.save
              @tid = @id
            end
        end        


      when "projects"
        case @mode
        when "deleted"
            project = Project.find(db_id)                  
            project.destroy
            @tid = @id

        when "updated"
            project = Project.find(db_id)
            project_from_params(project, @id)
            if project.save
              @tid = @id
            end
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


    link.sourceable = source_type.find(source_id)
    link.targetable = target_type.find(target_id)
    link.gtype      = params["#{id}_type"]
    # inherit project scope
    link.project_id = link.targetable.instance_of?(Project) ? link.targetable.id : link.targetable.project_id 
  end
 
end
