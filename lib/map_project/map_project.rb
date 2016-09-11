# If given zoom level, and center latlng, you can get:
# => pixel_per_lat
#    pixel_per_long

# If center latlng, latlng bound, you can get:
# => offset_on_viewport

# If given zoom level, center latlng, viewport size, you can get:
# => latlng bound
#    offset_on_viewport

module MapProject
  class MapProject
    attr_accessor :viewport_size, :pixel_per_lat, :pixel_per_long

    TILE_SIZE = 256.freeze
    FACTOR_TO_RAD = Rational(Math::PI, 180).freeze
    FACTOR_TO_DEG = Rational(180.0, Math::PI).freeze
    PIXEL_PER_DEG = Rational(TILE_SIZE, 360).freeze
    PIXEL_PER_RAD = Rational(TILE_SIZE, (2 * Math::PI)).freeze
    ZERO_ZERO_PX = [TILE_SIZE / 2, TILE_SIZE / 2].freeze

    def initialize(opts)
      @viewport_size = opts[:viewport_size]
      @center_lat = opts[:lat]
      @center_long = opts[:long]
      @zoom_level = opts[:zoom_level].nil? ? get_zoom_from_bound(opts[:bound]) : opts[:zoom_level]
      @center_lat_rad = FACTOR_TO_RAD * @center_lat
      @center_long_rad = FACTOR_TO_RAD * @center_long
      @center_lat_scaled_rad = Math.log( Math.tan( Rational(Math::PI,4) + Rational(@center_lat_rad,2)))
      @tile_number = 2 ** @zoom_level
    end

    # pixel per lat at current latlng and zoom level
    def pixel_per_lat
      @pixel_per_lat ||= (ZERO_ZERO_PX[0] + PIXEL_PER_RAD * @center_long_rad) * @tile_number
    end

    # pixel per long at current latlng and zoom level
    def pixel_per_long
      @pixel_per_long ||= (ZERO_ZERO_PX[1] - PIXEL_PER_RAD * @center_lat_scaled_rad) * @tile_number
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
      viewport_radius = viewport_size / 2
      max_lat = @center_lat + pixel_per_lat * viewport_radius
      min_lat = @center_lat - pixel_per_lat * viewport_radius
      max_long = @center_long + pixel_per_long * viewport_radius
      min_long = @center_long - pixel_per_long * viewport_radius
      {
        sw: [min_lat, min_long],
        ne: [max_lat, max_long]
      }
    end
  end
end
