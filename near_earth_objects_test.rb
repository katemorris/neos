require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require_relative 'near_earth_objects'

class NearEarthObjectsTest < Minitest::Test
  def setup
    @neo = NearEarthObjects.new
  end

  # def test_a_date_returns_a_list_of_neos
  #
  #   results = NearEarthObjects.find_neos_by_date('2019-03-31')
  #   assert_equal "163081 (2002 AG29)", results[:asteroid_list][0][:name]
  # end
  #
  # def test_it_can_pull_data_from_root_domain
  #   data = @neo.root_data('2020-06-21')
  #
  #   assert_equal URI::HTTPS, data.url_prefix.class
  # end
  #
  # def test_it_can_get_data_from_endpoint
  #   data = @neo.asteroids_list_data('2020-06-21')
  #
  #   assert_equal 200, data.status
  # end
  #
  # def test_it_can_return_parsed_data
  #   data = @neo.parsed_asteroids_data('2020-06-21')
  #
  #   assert_equal 14, data.count
  #   assert_equal Array, data.class
  # end

  def test_it_returns_largest_asteroid_by_diameter
    assert_equal 2691, @neo.largest_asteroid_diameter('2020-06-21')
    assert_equal 1664, @neo.largest_asteroid_diameter('2020-11-01')
  end

  def test_it_returns_total_number_of_asteroids
    assert_equal 14, @neo.total_number_of_asteroids('2020-06-21')
    assert_equal 8, @neo.total_number_of_asteroids('2020-07-01')
  end

  def test_it_will_return_formatted_ateroid_data
    expected = {
      name: "354952 (2006 FJ9)",
      diameter: "2691 ft",
      miss_distance: "26775821 miles"
    }

    assert_equal expected, @neo.formatted_asteroid_data('2020-06-21').first
  end
end
