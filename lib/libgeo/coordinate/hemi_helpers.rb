module Libgeo
  class Coordinate
    module HemiHelpers
      def north!
        return unless valid_hemisphere?(:N)
        @hemisphere = :N
      end

      def south!
        return unless valid_hemisphere?(:S)
        @hemisphere = :S
      end

      def west!
        return unless valid_hemisphere?(:W)
        @hemisphere = :W
      end

      def east!
        return unless valid_hemisphere?(:E)
        @hemisphere = :E
      end

      def north?
        normalize_hemi
        hemisphere == :N
      end

      def south?
        normalize_hemi
        hemisphere == :S
      end

      def west?
        normalize_hemi
        hemisphere == :W
      end

      def east?
        normalize_hemi
        hemisphere == :E
      end
    end
  end
end
