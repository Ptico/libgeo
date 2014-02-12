module Libgeo
  class Longitude < Coordinate

    HEMISPHERES = Set.new([:W, :E]).freeze

    POSITIVE_HEMISPHERE = :E
    NEGATIVE_HEMISPHERE = :W

    def type
      :longitude
    end

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
