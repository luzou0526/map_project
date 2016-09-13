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
  FACTOR_TO_RAD = Rational(Math::PI, 180).freeze
  FACTOR_TO_DEG = Rational(180.0, Math::PI).freeze
  PIXEL_PER_DEG = Rational(TILE_SIZE, 360).freeze
  PIXEL_PER_RAD = Rational(TILE_SIZE, (2 * Math::PI)).freeze
  ZERO_ZERO_PX = [TILE_SIZE / 2, TILE_SIZE / 2].freeze
  GOOGLE_MAPS_MAX_LAT = 85.05115.freeze
  GOOGLE_MAPS_MAX_LONG = 180.freeze

  class MapProject
    attr_accessor :viewport_size, :pixel_per_lat, :pixel_per_long, :world_coords, :center_lat,
                  :center_long, :geo_bounds_based_on_center, :pixel_bounds_based_on_center

    def initialize(opts)
      @viewport_w = opts[:viewport_w]
      @viewport_h = opts[:viewport_h]
      @center_lat = opts[:lat]
      @center_long = opts[:long]
      @zoom_level = opts[:zoom_level].nil? ? get_zoom_from_bound(opts[:bound]) : opts[:zoom_level]
      @tile_number = 2 ** @zoom_level
    end

    def world_coords
      @world_coords ||= lat_lng_to_world(@center_lat, @center_long)
    end

    def pixel_coords
      @pixel_coords ||= world_to_pixel(world_coords)
    end

    # pixel per lat at current latlng and zoom level
    def pixel_per_lat
      @pixel_per_lat ||= Rational(pixel_coords[0], GOOGLE_MAPS_MAX_LAT - @center_lat)
    end

    # pixel per long at current latlng and zoom level
    def pixel_per_long
      @pixel_per_long ||= Rational(pixel_coords[1], GOOGLE_MAPS_MAX_LONG + @center_long)
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
    # Usage example: css sprite
    def offset_on_viewport(p_lat, p_long)
      input_pixel_coords = world_to_pixel(lat_lng_to_world(p_lat, p_long))
      puts input_pixel_coords
      [
        (pixel_bounds_based_on_center[:ne][0] - input_pixel_coords[0]).abs,
        (pixel_bounds_based_on_center[:sw][1] - input_pixel_coords[1]).abs
      ]
      # lat_offset = ((p_lat - geo_bounds_based_on_center[:ne][0]) * pixel_per_lat).to_i.abs
      # long_offset = ((p_long - geo_bounds_based_on_center[:sw][1]) * pixel_per_long).to_i.abs
      # [lat_offset, long_offset]
    end

    # Return: pixel bounds of the viewport
    def pixel_bounds_based_on_center
      viewport_radius_w = @viewport_w / 2
      viewport_radius_h = @viewport_h / 2
      @pixel_bounds_based_on_center ||= {
          sw: [pixel_coords[0] + viewport_radius_h, pixel_coords[1] - viewport_radius_w],
          ne: [pixel_coords[0] - viewport_radius_h, pixel_coords[1] + viewport_radius_w]
      }
    end

    # Return: latlng bounds of the viewport
    def geo_bounds_based_on_center
      viewport_radius_w = @viewport_w / 2
      viewport_radius_h = @viewport_h / 2
      max_lat = @center_lat + Rational(viewport_radius_h, pixel_per_lat)
      min_lat = @center_lat - Rational(viewport_radius_h, pixel_per_lat)
      max_long = @center_long + Rational(viewport_radius_w, pixel_per_long)
      min_long = @center_long - Rational(viewport_radius_w, pixel_per_long)
      @geo_bounds_based_on_center ||= {
        sw: [min_lat, min_long],
        ne: [max_lat, max_long]
      }
    end

    private

    def lat_lng_to_world(p_lat, p_long)
      sin_y = Math.sin(Rational(p_lat * Math::PI, 180))
      sin_y = [[sin_y, -1].max, 1].min
      world_coord_long = TILE_SIZE * (0.5 + Rational(p_long, 360))
      world_coord_lat = TILE_SIZE * (0.5 - Rational(Math.log(Rational(1 + sin_y, 1 - sin_y)), 4 * Math::PI))
      [world_coord_lat, world_coord_long]
    end

    def world_to_pixel(world_coords)
      scale = 1 << @zoom_level
      [(world_coords[0] * scale).floor,
       (world_coords[1] * scale).floor]
    end
  end
end
