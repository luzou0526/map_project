require 'map_project/map_project.rb'

module MapProject
  LN2 = 0.6931471805599453.freeze
  WORLD_PX = 256.freeze
  ZOOM_MAX = 21.freeze
  # Get the zoom level for a viewport given latlng boundary
  def get_bounds_zoom_level(bounds, viewport_size)
    ne = bounds[:ne]
    sw = bounds[:sw]
    lat_fraction = (lat_rad(ne[0]) - lat_rad(sw[0])) / Math::PI
    lng_diff = ne[1] - sw[1]
    lng_fraction = ((lng_diff < 0) ? (lng_diff + 360) : lng_diff) / 360
    lat_zoom = zoom(viewport_size, WORLD_PX, lat_fraction)
    lng_zoom = zoom(viewport_size, WORLD_PX, lng_fraction)
    [[lat_zoom, lng_zoom].min, ZOOM_MAX].min
  end

  def lat_rad(lat)
    sin = Math.sin(lat * Math::PI / 180)
    rad_x2 = Math.log((1 + sin) / (1 - sin)) / 2
    [[rad_x2, Math::PI].min, -Math::PI].max / 2
  end

  def zoom(map_px, world_px, fraction)
    (Math.log(map_px / world_px / fraction) / LN2).floor
  end
end
