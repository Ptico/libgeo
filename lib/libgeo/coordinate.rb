require 'bigdecimal'
require 'bigdecimal/util'
require 'set'

require 'libgeo/coordinate/class_methods'
require 'libgeo/coordinate/presenters'
require 'libgeo/coordinate/hemi_helpers'

module Libgeo
  class Coordinate
    extend ClassMethods
    include Presenters
    include HemiHelpers

    HEMISPHERES = Set.new([:N, :E, :S, :W]).freeze
    NEGATIVE_HEMISPHERES = Set.new([:S, :W]).freeze

    attr_accessor :degrees, :minutes, :seconds, :hemisphere

    ##
    # Shortcuts
    alias :hemi :hemisphere
    alias :deg  :degrees
    alias :mins :minutes
    alias :secs :seconds

    def type
      nil
    end

    def minutes_only
      (minutes + seconds.to_d / 60).to_f
    end

    def valid_hemisphere?(value=nil)
      self.class::HEMISPHERES.include?(value || hemisphere)
    end

    def negative_hemisphere?
      if valid_hemisphere?
        NEGATIVE_HEMISPHERES.include?(hemi)
      elsif direction
        :< == direction
      else
        false
      end
    end

    def freeze
      normalize_data

      [@degrees, @minutes, @seconds, @hemisphere, @direction].each { |ivar| ivar.freeze }

      super
    end

  private

    attr_reader :direction

    def initialize(hemi_or_dir, degrees, minutes, seconds)
      @degrees = degrees
      @minutes = minutes
      @seconds = seconds

      if [:<, :>].include?(hemi_or_dir)
        @direction = hemi_or_dir
      else
        @hemisphere = hemi_or_dir
      end

      normalize_data
    end

    def normalize_data
      normalize_hemi
      normalize_values
    end

    def normalize_hemi
      if hemisphere
        normalize_hemi_wording
      elsif direction
        get_hemi_from_direction
      end
    end

    def normalize_hemi_wording
      unless valid_hemisphere?
        self.class::CORRECTIONS.each_pair do |v, c|
          @hemisphere = v if c.include?(hemisphere)
        end
      end
    end

    def get_hemi_from_direction
      @hemisphere = self.class::DIRECTIONS[direction]
    end

    def normalize_values
      @degrees = degrees.to_i
      @minutes = minutes.to_i
      @seconds = seconds.to_f
    end

  end
end
