# encoding: utf-8

require 'bigdecimal'
require 'bigdecimal/util'
require 'set'

require 'libgeo/coordinate/class_methods'
require 'libgeo/coordinate/presenters'
require 'libgeo/coordinate/hemi_helpers'

module Libgeo
  ##
  # Class: basic coordinate
  #
  # Provides basic functionality for Latitude and Longitude.
  # In some cases can be used as standalone class.
  #
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

    ##
    # Coordinate type
    #
    def type
      nil
    end

    ##
    # Decimal minutes with seconds included
    #
    # Returns: {Float} minutes
    #
    def minutes_only
      (minutes + seconds.to_d / 60).to_f
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
    def valid_hemisphere?(value=nil)
      self.class::HEMISPHERES.include?(value || hemisphere)
    end

    ##
    # Check if current hemisphere negative
    #
    # Returns: {Boolean}
    #
    def negative_hemisphere?
      if valid_hemisphere?
        NEGATIVE_HEMISPHERES.include?(hemi)
      elsif direction
        :< == direction
      else
        false
      end
    end

    ##
    # Freeze all the things!
    #
    def freeze
      normalize_data

      [@degrees, @minutes, @seconds, @hemisphere, @direction].each { |ivar| ivar.freeze }

      super
    end

  private

    attr_reader :direction

    ##
    # Constructor:
    #
    # Params:
    # - hemi_or_dir {Symbol|String} hemisphere value or direction
    # - degrees     {Fixnum}        degrees part
    # - minutes     {Fixnum}        minutes part
    # - seconds     {Float}         seconds part
    #
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

    ##
    # Private: make sure that all attrs has right types
    #
    def normalize_data
      normalize_hemi
      normalize_values
    end

    ##
    # Private: detect and assign hemisphere value
    #
    # Check if hemisphere can be properly detected
    # and assign it
    #
    def normalize_hemi
      if hemisphere
        normalize_hemi_wording
      elsif direction
        get_hemi_from_direction
      end
    end

    ##
    # Private: normalize hemisphere value
    #
    # If hemisphere have incorrect value - lookup for
    # available correction from dictionary
    #
    def normalize_hemi_wording
      unless valid_hemisphere?
        self.class::CORRECTIONS.each_pair do |v, c|
          @hemisphere = v if c.include?(hemisphere)
        end
      end
    end

    ##
    # Private: get hemisphere value from direction
    #
    # Mostly for plain Coordinate instance (not Latitude or Longitude)
    #
    def get_hemi_from_direction
      @hemisphere = self.class::DIRECTIONS[direction]
    end

    ##
    # Private: normalize attribute types
    #
    def normalize_values
      @degrees = degrees.to_i
      @minutes = minutes.to_i
      @seconds = seconds.to_f
    end

  end
end
