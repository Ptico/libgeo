module Libgeo
  class Coordinate
    module Presenters

      ##
      # Represent coordinate as float
      #
      # Returns: {Float} decimal coordinate
      #
      def to_f
        (negative_hemisphere? ? -1 : 1) * (degrees + minutes_only.to_d / 60).to_f
      end

      ##
      # Represent coordinate in NMEA format
      #
      # Params:
      # - formatter {Formatter} custom formatter (optional, default: '%2d%2M,%H')
      #
      # Returns: {String} formatted NMEA coordinate
      #
      def to_nmea(formatter=Format::NMEA_LAT)
        to_s(formatter)
      end

      ##
      # Format coordinate as string
      #
      # By default it uses standart DMS format
      #
      # Params:
      # - formatter {Formatter} custom formatter (optional, default: '%2d°%2m′%S″%H')
      #
      # Returns: {String} formatted string
      #
      def to_s(formatter=Format::DMS)
        formatter.format(self)
      end
      alias :to_dms :to_s

      ##
      # Represent coordinate as hash
      #
      # Returns: {Hash} with type, degrees, minutes, seconds and hemisphere
      #
      def to_hash
        {
          type:       type,
          degrees:    degrees,
          minutes:    minutes,
          seconds:    seconds,
          hemisphere: hemisphere
        }
      end

      ##
      # Inspect string
      #
      def inspect
        "#<#{self.class} hemisphere=#{hemisphere} degrees=#{degrees} minutes=#{minutes} seconds=#{seconds}>"
      end

    end
  end
end
