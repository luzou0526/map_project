# map_project
This gem provides a set of tools which can help users to map geo lat-lng to viewport coords. For example, you can use this gem to convert lat-long points to html `<div>` coords.

# Install
In Gemfile:
```ruby
gem 'map_project'
```
Then bundle:
```ruby
$ bundle install
```

# Usage:
***
If you have a boundary:
```ruby 
{sw: [MIN_LAT, MIN_LNG],
 ne: [MAX_LAT, MAX_LNG]})
``` 
and you know your viewport sizes (ex. width and height of a `<div>`), you can get the zoom level:
```ruby
zoom_level = get_bounds_zoom_level(boundary, viewport_width, viewport_height)
```
***
Once you get the zoom level, you can do a lot of more:<br />
First, create a map_project object:
```ruby
map_projection = MapProject.new({zoom_level: ZOOMLEVEL, lat: LAT, long: LNG, viewport_w: VIEWPORT_WIDTH, viewport_h: VIEWPORT_HEIGHT})
```
Example:
```ruby
map_projection = MapProject.new({zoom_level: 15, lat: 37.294742, long: -122.019252, viewport_w: 1024, viewport_h: 1024})
```

Then, you can:<br />
Convert lat-lng to Google World Coords:
```ruby
map_projection.world_coords
```
Convert lat-lng to Google Pixel Coords:
```ruby
map_projection.pixel_coords
```
Get number of pixels per latitude/longitude inside this map area:
```ruby
map_projection.pixel_per_lat
map_projection.pixel_per_long
```
Map any lat-lng points to coords on this viewport:
```ruby
map_project.offset_on_viewport(input_lat, input_long)
```
Get pixel boundary on this viewport:
```ruby
map_projection.pixel_bounds_based_on_center
```
Get actual geo boundary on this viewport:
```ruby
map_projection.geo_bounds_based_on_center
```
