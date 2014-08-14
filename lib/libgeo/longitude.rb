# encoding: utf-8

module Libgeo
  class Longitude < Coordinate

    ##
    # Constant: Valid hemisphere values
    #
    HEMISPHERES = Set.new([:W, :E]).freeze

    POSITIVE_HEMISPHERE = :E
    NEGATIVE_HEMISPHERE = :W

    MAX_DEGREES = 180

    ##
    # Coordinate type
    #
    def type
      :longitude
    end

    ##
    # Represent coordinate in NMEA format
    #
    # Params:
    # - formatter {Formatter} custom formatter (optional, default: '%2d%3M,%H')
    #
    # Returns: {String} formatted NMEA coordinate
    #
    def to_nmea(formatter=Format::NMEA_LON)
      to_s(formatter)
    end

  private

    CORRECTIONS = {
      W: Set.new(['W', 'west', :west]).freeze,
      E: Set.new(['E', 'east', :east]).freeze
    }.freeze

    DIRECTIONS = {
      :> => :E,
      :< => :W
    }.freeze

  end
end
