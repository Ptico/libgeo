module Libgeo
  class Coordinate
    module HemiHelpers

      ##
      # Make coordinate northen
      #
      def north!
        return unless valid_hemisphere?(:N)
        @hemisphere = :N
      end

      ##
      # Make coordinate southern
      #
      def south!
        return unless valid_hemisphere?(:S)
        @hemisphere = :S
      end

      ##
      # Make coordinate western
      #
      def west!
        return unless valid_hemisphere?(:W)
        @hemisphere = :W
      end

      ##
      # Make coordinate eastern
      #
      def east!
        return unless valid_hemisphere?(:E)
        @hemisphere = :E
      end

      ##
      # Check if coordinate in northen hemisphere
      #
      # Returns: {Boolean}
      #
      def north?
        normalize_hemi
        hemisphere == :N
      end

      ##
      # Check if coordinate in southern hemisphere
      #
      # Returns: {Boolean}
      #
      def south?
        normalize_hemi
        hemisphere == :S
      end

      ##
      # Check if coordinate in western hemisphere
      #
      # Returns: {Boolean}
      #
      def west?
        normalize_hemi
        hemisphere == :W
      end

      ##
      # Check if coordinate in eastern hemisphere
      #
      # Returns: {Boolean}
      #
      def east?
        normalize_hemi
        hemisphere == :E
      end
    end
  end
end
