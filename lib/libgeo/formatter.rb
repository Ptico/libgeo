require 'libgeo/formatter/compiler'
require 'libgeo/formatter/evaluator'

module Libgeo

  ##
  # Class: coordinate formatter
  #
  # Compiles sprintf-like patterns and present
  # given Coordinate as a DMS string
  #
  # Example:
  #
  #     coord = Latitude.new(:N, 48, 4, 15.7)
  #     my_format = Formatter.new('%H%d°%2M′')
  #     my_format.format(coord) # => 'N48°04.26306′'
  #
  #
  class Formatter

    ##
    # Source pattern
    #
    attr_reader :pattern

    ##
    # Create new string representing coordinate
    #
    # Params:
    # - coordinate {Latitude, Longitude} source coordinate
    # - evaluator  {Class}               private
    #
    # Returns: {String} formatted string
    #
    def format(coordinate, evaluator=Evaluator)
      evaluator.new(coordinate).instance_eval(expression)
    end

    ##
    # Represent instance as string
    #
    def inspect
      "#<Libgeo::Formatter pattern=(#{pattern})>"
    end
    alias :to_s :inspect
    alias :pretty_inspect :inspect

  private

    attr_reader :expression

    def initialize(pattern)
      @pattern    = pattern.freeze
      @expression = Compiler.new(pattern).compile
      freeze
    end

  end
end
