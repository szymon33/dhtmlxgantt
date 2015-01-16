# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

# DHTMLX Gantt files
Rails.application.config.assets.precompile += %w( 
  dhtmlxgantt.css 
  skins/dhtmlxgantt_skyblue.css
  dhtmlxgantt.js 
  locale/locale_pl.js 
  ext/dhtmlxgantt_marker.js 
  ext/dhtmlxgantt_quick_info.js
  ext/dhtmlxgantt_tooltip.js
)
