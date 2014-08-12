# encoding: utf-8

module Libgeo
  class Coordinate
    module ClassMethods

      # DMS_NOTATION = /-?[0-9]{2}(['°"`\ -][0-9]{2}){0,2}(\.[0-9]+)?(\ [ESWN])?/.freeze

      # NMEA_NOTATION = /[0-9]{5}\.[0-9]+((,|\ |,\ )[ESWN])?/.freeze

      DMS_SEPARATORS = /[^0-9\-.NWSE]+/.freeze

      NMEA_SEPARATORS = /(,\ |,|\ )/

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
        minutes = value.abs.to_d.modulo(1) * 60 # extract minutes from decimal degrees
        self.new(dir_from(value), value.abs.to_i, *min_with_sec(minutes))
      end

      ##
      # Factory: make a coordinate from nmea input
      #
      # Example:
      #
      #     Longitude.nmea('03920.56074,E') # => #<Longitude hemisphere=E degrees=39 minutes=20 ...
      #
      # Params:
      # - input {String} nmea coordinate
      #
      # Returns: {Latitude|Longitude|Coordinate} instance
      #
      def nmea(input)
        value, hemi = prepare_nmea(input)

        value = value.to_f

        direction = dir_from_values(value, hemi)

        degrees = value.to_i.abs / 100

        self.new(direction, degrees, *min_with_sec_nmea(value.abs))
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
        string_values = value.split(DMS_SEPARATORS)

        degrees = string_values[0].to_i # get degrees and minutes
        minutes = (string_values[1] || 0).to_i
        seconds = (string_values[2] || 0).to_f

        hemi = string_values[3]

        direction = dir_from_values(degrees, hemi)

        self.new(direction, degrees.abs, minutes, seconds)
      end

      ##
      # Factory: make a coordinate from degrees and full minutes
      #
      # Params:
      # - degrees {Fixnum} degrees part
      # - minutes {Float}  full minutes, with seconds
      #
      # Examples:
      #
      #     Latitude.degrees_minutes(-39, 20.56074) # => #<Latitude hemisphere=S degrees=39 minutes=20 ...
      #
      # Returns: {Latitude|Longitude|Coordinate} instance
      #
      def degrees_minutes(degrees, minutes)
        self.new(dir_from(degrees), degrees.abs.to_i, *min_with_sec(minutes))
      end

    private

      ##
      # Private: extract splited values from nmea notation
      #
      # Params:
      # - input {String} input string in nmea notation
      #
      # Examples:
      #     input # => "03922.54, E"
      #     prepare_nmea(input) # => ["03922.54", "E"]
      #
      #     input2 # => "+03922.54"
      #     prepare_nmea(input) # => ["+03922.54"]
      #
      # Returns: [{String}, {String}] numbers and hemisphere
      #
      def prepare_nmea(input)
        splited_values = input.split(NMEA_SEPARATORS)

        splited_values.delete_if { |str| str =~ NMEA_SEPARATORS }
      end

      ##
      # Private: extract integer minutes and  float seconds from float minutes
      #
      # Params:
      # - minutes {Float|Decimal} minutes
      #
      # Returns: [{Ineteger}, {Float}] rounded minutes and exracted seconds
      #
      def min_with_sec(minutes_f)
        seconds = minutes_f.to_d.modulo(1) * 60

        [minutes_f.to_i, seconds.to_f]
      end

      ##
      # Private: extract minutes and seconds from nmea coord
      #
      # Params:
      # - value {Float} nmea coordinate
      #
      # Returns: [{Ineteger}, {Float}] extracted minutes and seconds
      #
      def min_with_sec_nmea(value)
        minutes = value.to_i % 100
        seconds = (value.modulo(1) * 60).round(4)

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
