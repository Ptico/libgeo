module Libgeo
  class Coordinate
    module ClassMethods
      def decimal(value)
        self.new(dir_from(value), value.abs.to_i, *min_with_sec(value.abs))
      end

      def degrees_minutes(degrees, minutes)
        self.new(dir_from(degrees), degrees.abs.to_i, *min_with_sec(minutes / 60))
      end

    private

      def min_with_sec(value)
        minutes = value.to_d.modulo(1) * 60
        seconds = minutes.modulo(1) * 60

        [minutes.to_i, seconds.to_f]
      end

      def dir_from(degrees)
        degrees < 0 ? :< : :>
      end
    end
  end
end
