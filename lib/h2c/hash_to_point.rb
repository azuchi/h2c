# frozen_string_literal: true

module H2C
  # Complete and secure function for hashing strings to points.
  class HashToPoint

    attr_reader :suite

    # @param [H2C::Suite] suite Hash to curve suite
    def initialize(suite)
      @suite = suite
    end

    # Hash returns a point on an elliptic curve given a message.
    # @param [String] msg Message with binary to be hashed.
    # @return [ECDSA::Point]
    def digest(msg)
      if suite.ro
        u = hash_to_field(msg, 2)
      else
        u = hash_to_field(msg, 1)
      end


    end

    # Hashes a msg of any length into an element of a finite field.
    # https://www.ietf.org/archive/id/draft-irtf-cfrg-hash-to-curve-16.html#name-hash_to_field-implementatio
    # @param [String] msg A byte string containing the message to hash.
    # @param [Integer] count The number of elements of Field to output.
    # @return [Array]
    def hash_to_field(msg, count)
      field = suite.curve.field
      len = count * suite.m * suite.l
      pseudo = suite.exp.expand(msg, len)
      u = []
      (0...count).each do |i|
        v = []
        (0...suite.m).each do |j|
          offset = suite.l * (j + i * suite.m)
          t = pseudo[offset, (offset + suite.l)]
          vj = t.unpack1('H*').to_i(16)
          v[j] = field.mod(vj)
        end
        u[i] = v
      end
      u
    end
  end
end
