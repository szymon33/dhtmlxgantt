# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Gantt example data

if Task.all.empty?
  Task.create(text: "Project #1", start_date: "2013-04-01", duration:11, progress: 0.6)
  Task.create(text: "Task #1", start_date: "2013-04-03", duration:5, progress: 1)
  Task.create(text: "Task #2", start_date: "2013-04-03", duration:7, progress: 0.4)
  Task.create(text: "Task #2.1", start_date: "2013-04-03", duration:2, progress: 1)
  Task.create(text: "Task #2.2", start_date: "2013-04-04", duration:3, progress: 0.8)
  Task.create(text: "Task #2.3", start_date: "2013-04-05", duration:4, progress: 0.2)        
  GanttLink.create(source: 1, target: 2, gtype:"1")
  GanttLink.create(source: 1, target: 3, gtype:"1")
  GanttLink.create(source: 3, target: 4, gtype:"1")
  GanttLink.create(source: 4, target: 5, gtype:"0")
  GanttLink.create(source: 5, target: 6, gtype:"0")        
end
