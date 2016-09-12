# If given zoom level, and center latlng, you can get:
# => pixel_per_lat
#    pixel_per_long

# If center latlng, latlng bound, you can get:
# => offset_on_viewport

# If given zoom level, center latlng, viewport size, you can get:
# => latlng bound
#    offset_on_viewport

module MapProject
  TILE_SIZE = 256.freeze
  ZOOM_ZERO_PIX_FACTOR = 7.freeze
  FACTOR_TO_RAD = Rational(Math::PI, 180).freeze
  FACTOR_TO_DEG = Rational(180.0, Math::PI).freeze
  PIXEL_PER_DEG = Rational(TILE_SIZE, 360).freeze
  PIXEL_PER_RAD = Rational(TILE_SIZE, (2 * Math::PI)).freeze
  ZERO_ZERO_PX = [TILE_SIZE / 2, TILE_SIZE / 2].freeze
  GOOGLE_MAPS_MAX_LAT = 85.05115.freeze
  GOOGLE_MAPS_MAX_LONG = 180.freeze

  class MapProject
    attr_accessor :viewport_size, :pixel_per_lat, :pixel_per_long, :world_coords

    def initialize(opts)
      @viewport_size = opts[:viewport_size]
      @center_lat = opts[:lat]
      @center_long = opts[:long]
      @zoom_level = opts[:zoom_level].nil? ? get_zoom_from_bound(opts[:bound]) : opts[:zoom_level]
      @tile_number = 2 ** @zoom_level
      @map_size = @tile_number * TILE_SIZE
    end

    def world_coords
      sin_y = Math.sin(Rational(@center_lat * Math::PI, 180))
      sin_y = [[sin_y, -0.9999].max, 0.9999].min
      world_coord_long = TILE_SIZE * (0.5 + Rational(@center_long, 360))
      world_coord_lat = TILE_SIZE * (0.5 - Rational(Math.log(Rational(1 + sin_y, 1 - sin_y)), 4 * Math::PI))
      @world_coords ||= [world_coord_long, world_coord_lat]
    end

    def pixel_coords
      scale = 1 << @zoom_level
      @pixel_coords ||= [(world_coords[0] * scale).floor,
                         (world_coords[1] * scale).floor]
    end

    # pixel per lat at current latlng and zoom level
    def pixel_per_lat
      @pixel_per_lat ||= Rational(pixel_coords[1], GOOGLE_MAPS_MAX_LAT - @center_lat)
    end

    # pixel per long at current latlng and zoom level
    def pixel_per_long
      @pixel_per_long ||= Rational(pixel_coords[0], 180 + @center_long)
    end

    # project the map coords to viewport, return a point's offsets on viewport
    # (0,0)         (0, x)
    #     ------------
    #     |          |
    #     | viewport |
    #     |          |
    #     ------------
    # (y, 0)        (x, y)
    # Return: the projected offset of the point
    def offset_on_viewport(p_lat, p_long, bound)
      x_offset = ((p_lat - bound[:sw][0]) * pixel_per_lat).abs
      y_offset = ((p_long - bound[:ne][1]) * pixel_per_long).abs
      [x_offset, y_offset]
    end

    # Return: latlng bounds of the viewport
    def get_bounds_with_center
      viewport_radius = @viewport_size / 2
      max_lat = @center_lat + Rational(viewport_radius, pixel_per_lat)
      min_lat = @center_lat - Rational(viewport_radius, pixel_per_lat)
      max_long = @center_long + Rational(viewport_radius, pixel_per_long)
      min_long = @center_long - Rational(viewport_radius, pixel_per_long)
      {
        sw: [min_lat, min_long],
        ne: [max_lat, max_long]
      }
    end
  end
end
