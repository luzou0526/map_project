require File.expand_path('../../../lib/map_project.rb', __FILE__)

describe 'map_project' do
  include MapProject

  TEST_VIEW_PORT_HEIGHT = 1024.freeze
  TEST_VIEW_PORT_WIDTH = 1024.freeze

  let(:map_project_test_bounds) do
    {
      :sw => [ 37.176897, -121.976457],
      :ne => [ 37.429432000000006, -121.75589500000001]
    }
  end

  describe '#get_bounds_zoom_level' do
    it 'should return a proper zoom level covers the bounds' do
      expect(get_bounds_zoom_level(map_project_test_bounds, TEST_VIEW_PORT_WIDTH, TEST_VIEW_PORT_HEIGHT)).to eq(12)
    end
  end

  let(:map_project_test_obj) do
    MapProject::MapProject.new({zoom_level: 12, lat: 37.3031645, long: -121.866176, viewport_w: TEST_VIEW_PORT_WIDTH, viewport_h: TEST_VIEW_PORT_HEIGHT})
  end

  describe 'MapProject class' do
    it 'world_coords' do
       expect(map_project_test_obj.world_coords).to eq([99.37241713266029, 41.33960817777778])
    end

    it 'pixel_coords' do
      expect(map_project_test_obj.pixel_coords).to eq([407029, 169327])
    end

    it 'pixel_per_lat' do
      expect(map_project_test_obj.pixel_per_lat).to eq(Rational(57284239147780800512, 6719931553296621))
    end

    it 'pixel_per_long' do
      expect(map_project_test_obj.pixel_per_long).to eq(Rational(372354010792853504, 127837630910167))
    end

    it 'offset_on_viewport' do
       expect(map_project_test_obj.offset_on_viewport(37.3, -121.8)).to eq([704, 524])
    end

    it 'pixel_bounds_based_on_center' do
      expect(map_project_test_obj.pixel_bounds_based_on_center).to eq({:sw=>[407541, 168815], :ne=>[406517, 169839]})
    end

    it 'geo_bounds_based_on_center' do
      expect(map_project_test_obj.geo_bounds_based_on_center).to eq({:sw=>[37.24310251774321, -122.04195728643394],
                                                                     :ne=>[37.36322648225679, -121.69039471356605]})
    end

  end
end
