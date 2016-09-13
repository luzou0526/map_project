# map_project
This gem provides a set of tools which can help users to map geo lat-lng to viewport coords. For example, you can use this gem to convert lat-long points to html `<div>` coords.

# Install
In Gemfile:
```ruby
gem 'map_project'
```
and bundle:
```ruby
$ bundle install
```
Then, include: 
```ruby
include MapProject
```
In any files you need.

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
map_projection = MapProject.new({zoom_level: ZOOMLEVEL, lat: LAT, long: LONG, viewport_w: VIEWPORT_WIDTH, viewport_h: VIEWPORT_HEIGHT})
```
The `:lat` and `:long` are the geo position of the center.
Example:
```ruby
map_projection = MapProject.new({zoom_level: 15, lat: 37.294742, long: -122.019252, viewport_w: 1024, viewport_h: 1024})
```

Then, you can:<br />
Convert geo lat-lng to Google World Coords:
```ruby
map_projection.world_coords
```
Convert geo lat-lng to Google Pixel Coords:
```ruby
map_projection.pixel_coords
```
Get number of pixels per latitude/longitude inside this map area:
```ruby
map_projection.pixel_per_lat
map_projection.pixel_per_long
```
Map any geo lat-lng points to viewport coords:
```ruby
(0,0)         (0, x)
     ------------
     |          |
     | viewport |
     |          |
     ------------
(y, 0)        (x, y)
map_project.offset_on_viewport(input_lat, input_long)
```
Get pixel boundary on this viewport:
```ruby
map_projection.pixel_bounds_based_on_center
```
The input boundary you used for getting zoom level may be different from the real boundary on map.
Get actual geo boundary on this viewport:
```ruby
map_projection.geo_bounds_based_on_center
```
