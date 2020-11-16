require 'faraday'
require 'figaro'
# Load ENV vars via Figaro
Figaro.application = Figaro::Application.new(environment: 'production', path: File.expand_path('../config/application.yml', __FILE__))
Figaro.load

# How do I use private in this class?
class NearEarthObjects
  def root_data(date)
    Faraday.new(
      url: 'https://api.nasa.gov',
      params: { start_date: date, api_key: ENV['nasa_api_key']}
    )
  end

  def asteroids_list_data(date)
    root_data(date).get('/neo/rest/v1/feed')
  end

  def parsed_asteroids_data(date)
    JSON.parse(asteroids_list_data(date).body, symbolize_names: true)[:near_earth_objects][:"#{date}"]
  end

  def largest_asteroid_diameter(date)
    parsed_asteroids_data(date).map do |asteroid|
      asteroid[:estimated_diameter][:feet][:estimated_diameter_max].to_i
    end.max { |a,b| a<=> b}
  end

  def total_number_of_asteroids(date)
    parsed_asteroids_data(date).count
  end

  def formatted_asteroid_data(date)
    parsed_asteroids_data(date).map do |asteroid|
      {
        name: asteroid[:name],
        diameter: "#{asteroid[:estimated_diameter][:feet][:estimated_diameter_max].to_i} ft",
        miss_distance: "#{asteroid[:close_approach_data][0][:miss_distance][:miles].to_i} miles"
      }
    end
  end

  def self.find_neos_by_date(date)
    new = NearEarthObjects.new
    {
      asteroid_list: new.formatted_asteroid_data(date),
      biggest_asteroid: new.largest_asteroid_diameter(date),
      total_number_of_asteroids: new.total_number_of_asteroids(date)
    }
  end
end
