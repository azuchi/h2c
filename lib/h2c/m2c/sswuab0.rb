# frozen_string_literal: true
module H2C
  module M2C
    # https://www.ietf.org/archive/id/draft-irtf-cfrg-hash-to-curve-16.html#section-6.6.3
    class SSWUAB0
      attr_reader :sswu, :iso

      # Constructor
      # @param [H2C::M2C::ISOGeny] iso
      # @param [Integer] z
      def initialize(iso, z)
        @sswu = SSWU.new(iso.e0, z)
        @iso = iso
      end

      # https://www.ietf.org/archive/id/draft-irtf-cfrg-hash-to-curve-16.html#section-6.6.3
      # @param [Integer] u
      # @return [ECDSA::Point]
      def map(u)
        x, y = sswu.map(u)
        coordinate = iso.map(x, y)
        iso.e1.new_point(coordinate)
      end
    end
  end
end
