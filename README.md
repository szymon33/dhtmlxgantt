# RoR implementation of dhtmlx Gantt chart

[![Code Climate](https://codeclimate.com/github/szymon33/dhtmlxgantt/badges/gpa.svg)](https://codeclimate.com/github/szymon33/dhtmlxgantt)

The Dhtmlxagantt is an application which implements [dhtmlx](http://dhtmlx.com/) Gantt chart in Rails framework as simple as possible. This document contains implementation notes and gotcha's.

You can read about Gantt chart [here](http://en.wikipedia.org/wiki/Gantt_chart).

You can read about dhtmlx and their awsome interactive JavaScript Gantt chart [here](http://dhtmlx.com/docs/products/dhtmlxGantt/).

## Components

* Rails version 4.1

* GUI component dhtmlx gantt version 3.1 (standard version)

* Ruby version 2.1

## Limiting dhtmlx default widget configuration

Default Gantt chart component functionality is shrinked here as follows: 

1. You can overview just one project on the chart. 

2. You can add task (using plus icon) to the project but you can not add task to the task (subtask). 
If you want to omit these limitation and keep standard edition then simply take out the following code.

    ```css
    <style>
      [task_id^='task-'] .gantt_add, .gantt_grid_head_add {
        display: none !important;
      }
    </style>
    ```

    from your `index.html.erb` file.

3. You can add only tasks but not a project because functionality of milestones, projects and adding custom types has been moved to PRO version (commercial or enterprise editions).


## Asset pipeline

No CSS or JS files will be available to your app through the asset pipeline unless they are listed in the `config.precompile` directive 

  ```ruby
  Rails.application.config.assets.precompile += %w( 
    dhtmlxgantt.css 
    skins/dhtmlxgantt_skyblue.css
    dhtmlxgantt.js 
    locale/locale.js 
    ext/dhtmlxgantt_marker.js 
    ext/dhtmlxgantt_quick_info.js
    ext/dhtmlxgantt_tooltip.js
  )
  ```

in your `config/initializers/assets.rb` file.

## Usage notes

Gantt charts illustrate the start and finish dates of the terminal elements and summary elements of a project thus if your task has not `start_date` nor `duration` then it will not show up.

In this example if you delete a project then all its links and tasks will be deleted too. Then you can continue by adding tasks which are not related (linked) to any project.

## Demo

There are some task examples in `db/seeds.rb` file. So, you might begin with run `rake db:setup`

and your demo chart should look like this

![Screentshot](https://raw.github.com/szymon33/dhtmlxgantt/master/screenshot1.png)

![Screentshot](https://raw.github.com/szymon33/dhtmlxgantt/master/screenshot2.png)
