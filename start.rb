require_relative 'near_earth_objects'
require_relative 'display'

Display.intro
date = gets.chomp
neo = Display.new(NearEarthObjects.find_neos_by_date(date))
neo.output(date)
