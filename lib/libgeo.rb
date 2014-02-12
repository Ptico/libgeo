require 'set'

require 'libgeo/version'
require 'libgeo/formatter'

module Libgeo

  NORTH = :N
  SOUTH = :S
  WEST  = :W
  EAST  = :E

  module Format
    DMS      = Formatter.new('%2d°%2m′%S″%H')
    NMEA_LAT = Formatter.new('%2d%2M,%H')
    NMEA_LON = Formatter.new('%3d%2M,%H')
  end
end

require 'libgeo/coordinate'
require 'libgeo/latitude'
require 'libgeo/longitude'
