module Libgeo
  class Coordinate
    module Presenters
      def to_f
        (negative_hemisphere? ? -1 : 1) * (degrees + minutes_only.to_d / 60).to_f
      end

      def to_nmea(formatter=Format::NMEA_LAT)
        to_s(formatter)
      end

      def to_utm

      end

      def to_s(formatter=Format::DMS)
        formatter.format(self)
      end
      alias :to_dms :to_s

      def to_hash
        {
          type:       type,
          degrees:    degrees,
          minutes:    minutes,
          seconds:    seconds,
          hemisphere: hemisphere
        }
      end

      def inspect
        "#<#{self.class} hemisphere=#{hemisphere} degrees=#{degrees} minutes=#{minutes} seconds=#{seconds}>"
      end

    end
  end
end
