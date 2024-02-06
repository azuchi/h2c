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
    # @return [ECDSA::Point] point
    def digest(msg)
      p =
        if suite.ro
          u = hash_to_field(msg, 2)
          p0 = suite.map.map(u[0])
          p1 = suite.map.map(u[1])
          p0 + p1
        else
          u = hash_to_field(msg, 1)
          suite.map.map(u[0])
        end
      suite.curve.cofactor ? p.multiply_by_scalar(suite.curve.cofactor) : p
    end

    # Hashes a msg of any length into an element of a finite field.
    # https://www.ietf.org/archive/id/draft-irtf-cfrg-hash-to-curve-16.html#name-hash_to_field-implementatio
    # @param [String] msg A byte string containing the message to hash.
    # @param [Integer] count The number of elements of Field to output.
    # @param [Integer] modulo (Optional) This value is a finite field of characteristic p in the
    # hash to curve specification. Other protocols such as FROST can be order of curve.
    # @return [Array]
    def hash_to_field(msg, count, modulo = suite.curve.field.prime)
      len = count * suite.m * suite.l
      pseudo = suite.exp.expand(msg, len)
      u = []
      count.times do |i|
        v = []
        suite.m.times do |j|
          offset = suite.l * (j + i * suite.m)
          t = pseudo[offset, (offset + suite.l)]
          vj = t.unpack1("H*").to_i(16)
          v[j] = vj % modulo
        end
        u[i] = v
      end
      u.flatten
    end
  end
end
