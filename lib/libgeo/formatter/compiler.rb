# encoding: utf-8

require 'strscan'

module Libgeo
  class Formatter

    ##
    # Class: template compiler
    #
    # Tooks the sprintf-like pattern string
    # and compiles it to the ruby code
    #
    # Example:
    #
    #     Compiler.new('%d:%2m').compile
    #
    class Compiler

      ##
      # Constant: set of keywords
      #
      # Defines keywords and corresponding ruby methods
      # where `c` is a given coordinate object
      #
      KEYWORDS = {
        'd' => 'c.deg',
        'm' => 'c.mins',
        'M' => 'c.minutes_only',
        's' => 'c.secs.to_i',
        'S' => 'c.secs',
        'h' => 'c.hemi.to_s.downcase',
        'H' => 'c.hemi'
      }.freeze

      TOKEN_REG  = /%\d?\w/.freeze
      STRING_REG = /./.freeze

      ##
      # Resulted ruby expression
      #
      attr_reader :result

      ##
      # Compile the template
      #
      # Returns: {String} ruby expression
      #
      def compile
        return result if result

        scan until scanner.eos?

        finalize_string

        @result = parts.join(' << ').freeze
      end

    private

      attr_reader :scanner, :parts

      ##
      # Constructor:
      #
      # Params:
      # - pattern {String} pattern string
      #
      def initialize(pattern)
        @scanner = StringScanner.new(pattern)
        @parts   = []
        @curr_string = ''
      end

      ##
      # Private: scan for subsrings and process them
      #
      def scan
        if key = scanner.scan(TOKEN_REG)
          finalize_string
          process_token(key)
        else
          @curr_string << scanner.scan(STRING_REG)
        end
      end

      ##
      # Private: process % tokens
      #
      # When % token given - we split it to the parts: key and pad.
      # For example `%2m` will have key `m` and pad `2`
      # Then we add corresponding ruby code to buffer
      # and wrap it with `pad()` function if pad given.
      # For `%2m` we will receive `pad(c.mins.to_s, 2)` instruction
      #
      # Params:
      # - key {String} matched % substring
      #
      def process_token(token)
        key = token[-1]
        pad = token[1..-2].to_i

        instr = KEYWORDS[key] + '.to_s'
        instr = "pad(#{instr}, #{pad})" if pad > 0

        parts << instr
      end

      ##
      # Private: finalize plain string
      #
      # To avoid redundant string operations in the final
      # expression, we store each matched substring in the temporary
      # instance variable. When the next % token given - we
      # concatenate the content of this variable and clean it.
      # As a result, we have string 'foo' instead of 'f' << 'o' << 'o'
      #
      def finalize_string
        unless @curr_string.empty?
          parts << %('#{@curr_string}')
          @curr_string = ''
        end
      end

    end

  end
end
