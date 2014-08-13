# encoding: utf-8

module Libgeo
  class Coordinate
    module ClassMethods

      DMS_SEPARATORS  = /['°′"`\ \,]+/.freeze
      NMEA_SEPARATORS = /(,\ |,|\ )/.freeze

      ##
      # Factory: make a coordinate from decimal value
      #
      # Examples:
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
        create(dir_from(value), value.abs.to_i, *min_with_sec(minutes))
      end

      ##
      # Factory: make a coordinate from nmea input
      #
      # Examples:
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

        create(direction, degrees, *min_with_sec_nmea(value.abs), hemi)
      end

      ##
      # Factory: make a coordinate from dms value
      #
      # Examples:
      #
      #     Longitude.dms("58°39′13.5 S") # => #<Longitude hemisphere=S degrees=58 minutes=39 ...
      #
      # Params:
      # - inputs {String} dms coordinate
      #
      # Returns: {Latitude|Longitude|Coordinate} instance
      #
      def dms(input)
        string_values = input.split(DMS_SEPARATORS)

        degrees = string_values[0].to_i # get degrees and minutes
        minutes = (string_values[1] || 0).to_i
        seconds = (string_values[2] || 0).to_f
        hemi    = string_values[3]

        direction = dir_from_values(degrees, hemi)

        create(direction, degrees.abs, minutes, seconds, hemi)
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
        create(dir_from(degrees), degrees.abs.to_i, *min_with_sec(minutes))
      end

    private

      ##
      # Private: extract splited values from nmea notation
      #
      # Params:
      # - input {String} input string in nmea notation
      #
      # Examples:
      #
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
      # Params:
      # - degrees {Integer} degrees
      #
      # Examples:
      #
      #     dir_from(-5) # => :<
      #     dir_from(10) # => :>
      #
      # Returns: {Symbol} symbol of direction
      #
      def dir_from(degrees)
        degrees < 0 ? :< : :>
      end

      ##
      # Private: detect direction from degrees of hemisphere
      #
      # Params:
      # - numbers {Ineteger|Float|Decimal} numerical value of coordinate (degrees)
      # - hemi {String|Symbol|nil} hemisphere if available
      #
      # Examples:
      #
      #     dir_from_values(43, 'S') # => :<
      #     dir_from_values(43, nil) # => :>
      #
      # Returns: {Symbol} symbol of direction
      #
      def dir_from_values(numbers, hemi)
        if hemi
          (NEGATIVE_HEMISPHERES.include? hemi.to_sym) ? :< : :>
        else
          dir_from(numbers.to_i)
        end
      end

      def create(direction, degrees, minutes, seconds, hemi=nil)
        validate_values(degrees, minutes, seconds, hemi)

        self.new(direction, degrees, minutes, seconds)
      end

      def validate_values(degrees, minutes, seconds, hemi)
        if degrees > self::MAX_DEGREES || minutes > 60 || seconds > 60
          raise ArgumentError.new('values out of range')
        end

        valid_hemisphere? hemi.to_sym if hemi
      end


      ##
      # Hemisphere validator
      #
      # Validates if given value can be assigned to Coordinate
      # or if current hemi is valid
      #
      # Params:
      # - value hemisphere value to check (optional)
      #
      # Returns: {Boolean}
      #
      def valid_hemisphere?(value)
        raise ArgumentError.new('wrong hemisphere') unless HEMISPHERES.include?(value)
      end
    end
  end
end
