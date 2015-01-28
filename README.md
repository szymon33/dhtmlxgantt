# RoR implementation of dhtmlx Gantt chart

The Dhtmlxagantt is an application which implements [dhtmlx](http://dhtmlx.com/) Gantt chart in Rails framework as simple as possible. This document contains implementation notes and gotcha's.

You can read about Gantt chart [here](http://en.wikipedia.org/wiki/Gantt_chart).

You can read about dhtmlx and their awsome interactive JavaScript Gantt chart [here](http://dhtmlx.com/docs/products/dhtmlxGantt/).

## Components

* Rails version 4.1

* GUI widget dhtmlx gantt version 3.1 (standard licence)

* Ruby version 2.1

## Limit the default widget

Default Gantt chart widget functionality is shrinked here. There is just one project and its tasks on the chart. You can add tasks (using plus icon) to the project but you can not add tasks to the task (subtasks). Further, you can not add new project on the chart. You have to create project separately. If you want to omit these limitations then simply take out the following code.

```css
<style>
  [task_id^='task-'] .gantt_add, .gantt_grid_head_add {
    display: none !important;
  }
</style>
```

from your `index.html.erb` file.

## Assets pipeline

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

## Task examples

There are some task examples in `db/seeds.rb` file. So, you might begin with run `rake db:setup`

and your chart should look like this

![Screentshot](https://raw.github.com/szymon33/dhtmlxgantt/master/screenshot1.png)

![Screentshot](https://raw.github.com/szymon33/dhtmlxgantt/master/screenshot2.png)
