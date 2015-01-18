# RoR implementation of dhtmlx Gantt chart

The Dhtmlxagantt is an application which implements [dhtmlx](http://dhtmlx.com/) Gantt chart in Rails framework as simple as possible. This document contains implementation notes and gotcha's.

You can read about Gantt chart [here](http://en.wikipedia.org/wiki/Gantt_chart).

You can read about dhtmlx and their awsome interactive JavaScript Gantt chart [here](http://dhtmlx.com/docs/products/dhtmlxGantt/).

## Components

* Rails version 4.1

* GUI widget dhtmlx gantt version 3.1 (standard licence)

* Ruby version 2.1

## Notes

No CSS or JS files will be available to your app through the asset pipeline unless they are listed in the `config.precompile` directive 

```ruby
Rails.application.config.assets.precompile += %w( 
  dhtmlxgantt.css 
  skins/dhtmlxgantt_skyblue.css
  dhtmlxgantt.js 
  locale/locale_en.js 
  ext/dhtmlxgantt_marker.js 
  ext/dhtmlxgantt_quick_info.js
  ext/dhtmlxgantt_tooltip.js
)
```

in your `/config/initializers/assets.rb` file.

## Task examples

There are some task examples in `db/seeds.rb` file. So you can run `rake db:setup`

and it should look like this

![Screentshot](https://raw.github.com/szymon33/dhtmlxgantt/master/screenshot1.png)