module Libgeo
  class Latitude < Coordinate

    HEMISPHERES = Set.new([:N, :S]).freeze

    POSITIVE_HEMISPHERE = :N
    NEGATIVE_HEMISPHERE = :S

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
