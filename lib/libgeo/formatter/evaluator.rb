module Libgeo
  class Formatter

    ##
    # Class: sandbox for evaluating compiled expressions
    #
    class Evaluator < BasicObject

      ##
      # Coordinate
      #
      attr_reader :c

      ##
      # Add leading zeroes if needed
      #
      # Adds leading zeroes in case if int part of
      # number doesn't have needed length
      #
      # Example:
      #
      #     pad('3.14', 2)  # => '03.14'
      #     pad('13.14', 2) # => '13.14'
      #     pad(42, 3)      # => '042'
      #
      # Params:
      # - val {String|Numeric} number to process
      # - num {Fixnum}          length of int part
      #
      # Returns: {String} number with or without zeroes added
      #
      def pad(val, i)
        val    = val.to_s.split('.')
        val[0] = add_zeroes(val[0], i)
        val.join('.')
      end

    private

      def initialize(coordinate)
        @c = coordinate
      end

      def add_zeroes(val, i)
        num = i - val.length
        num = num > 0 ? num : 0
        ('0' * num) + val
      end
    end
  end
end
