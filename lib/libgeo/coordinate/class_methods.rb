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
      # Factory: make a coordinate from nmea value
      #
      # Example:
      #
      #     Longitude.nmea('03920.56074,E') # => #<Longitude hemisphere=E degrees=39 minutes=20 ...
      #
      # Params:
      # - value {String} nmea coordinate
      #
      # Returns: {Latitude|Longitude|Coordinate} instance
      #
      def nmea(value)
        numbers, char = value.split(',')
        numbers = numbers.to_f
        
        direction = dir_from_values(numbers, char)

        degrees = numbers.to_i.abs / 100

        self.new(direction, degrees, *min_with_sec_nmea(numbers.abs))
      end

      ##
      # Factory: make a coordinate from dms value
      #
      # Example:
      #
      #     Longitude.dms("58°39′13.5 S") # => #<Longitude hemisphere=S degrees=58 minutes=39 ...
      #
      # Params:
      # - value {String} dms coordinate
      #
      # Returns: {Latitude|Longitude|Coordinate} instance
      #
      def dms(value)
        string_values = value.split(/[^0-9\-.NWSE]/)

        degrees, minutes = string_values.map{ |x| x.to_i }[0, 2] # get degrees and minutes 

        seconds = string_values[2].to_f

        char = string_values[3]
        
        direction = dir_from_values(degrees, char)

        self.new(direction, degrees.abs, minutes, seconds)
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
      # Private: calculate minutes and seconds from nmea coord
      #
      def min_with_sec_nmea(value)
        minutes = value.to_i % 100
        seconds = (value.modulo(1)*60).round 4
        [minutes, seconds]
      end      

      ##
      # Private: detect direction based on neg/pos
      #
      def dir_from(degrees)
        degrees < 0 ? :< : :>
      end

      ##
      # Private: detect direction based on nmea or dms notation
      #
      def dir_from_values(numbers, char)
        if char  
          (NEGATIVE_HEMISPHERES.include? char.to_sym) ? :< : :>
        else
          dir_from(numbers.to_i)
        end
      end      
    end
  end
end
