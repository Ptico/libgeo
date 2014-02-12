# encoding: utf-8

module Libgeo
  class Latitude < Coordinate

    ##
    # Constant: Valid hemisphere values
    #
    HEMISPHERES = Set.new([:N, :S]).freeze

    POSITIVE_HEMISPHERE = :N
    NEGATIVE_HEMISPHERE = :S

    ##
    # Coordinate type
    #
    def type
      :latitude
    end

  private

    CORRECTIONS = {
      N: Set.new(['N', 'north', :north]).freeze,
      S: Set.new(['S', 'south', :south]).freeze
    }.freeze

    DIRECTIONS = {
      :> => :N,
      :< => :S
    }.freeze

  end
end
