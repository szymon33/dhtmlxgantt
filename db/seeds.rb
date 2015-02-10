# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Gantt example data

if Task.gantt_data.empty?
  p  = Project.create(name: "Project #1")
  t1 = Task.create(name: "Task #1", start_date: "2015-04-03", duration:5, progress: 1)
  t2 = Task.create(name: "Task #2", start_date: "2015-04-03", duration:1, progress: 0.4)
  t3 = Task.create(name: "Task #2.1", start_date: "2015-04-04", duration:2, progress: 1, parent: t2.id)
  t4 = Task.create(name: "Task #2.2", start_date: "2015-04-04", duration:3, progress: 0.8, parent: t2.id)
  t5 = Task.create(name: "Task #2.3", start_date: "2015-04-05", duration:4, progress: 0.2, parent: t2.id) 
  p.tasks << [t1, t2, t3, t4, t5]

  GanttLink.create(sourceable: t1, targetable: t2, gtype:"1", project: p)
  GanttLink.create(sourceable: t2, targetable: t3, gtype:"0", project: p)
  GanttLink.create(sourceable: t3, targetable: t4, gtype:"1", project: p)  
end
