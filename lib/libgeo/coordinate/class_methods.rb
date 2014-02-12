# encoding: utf-8

module Libgeo
  class Coordinate
    module ClassMethods

      ##
      # Factory: make a coordinate from decimal value
      #
      # Example:
      #
      #     Longitude.decimal(39.342679) # => #<Longitude hemisphere=E degrees=39 minutes=20 ...
      #
      # Params:
      # - value {Float} decimal coordinate
      #
      # Returns: {Latitude|Longitude|Coordinate} instance
      #
      def decimal(value)
        self.new(dir_from(value), value.abs.to_i, *min_with_sec(value.abs))
      end

      ##
      # Factory: make a coordinate from degrees and full minutes
      #
      # Example:
      #
      #     Latitude.degrees_minutes(-39, 20.56074) # => #<Latitude hemisphere=S degrees=39 minutes=20 ...
      #
      # Params:
      # - degrees {Fixnum} degrees part
      # - minutes {Float}  full minutes, with seconds
      #
      # Returns: {Latitude|Longitude|Coordinate} instance
      #
      def degrees_minutes(degrees, minutes)
        self.new(dir_from(degrees), degrees.abs.to_i, *min_with_sec(minutes / 60))
      end

    private

      ##
      # Private: calculate minutes and seconds from decimal coord
      #
      def min_with_sec(value)
        minutes = value.to_d.modulo(1) * 60
        seconds = minutes.modulo(1) * 60

        [minutes.to_i, seconds.to_f]
      end

      ##
      # Private: detect direction based on neg/pos
      #
      def dir_from(degrees)
        degrees < 0 ? :< : :>
      end
    end
  end
end
