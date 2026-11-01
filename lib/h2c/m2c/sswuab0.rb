# frozen_string_literal: true
module H2C
  module M2C
    # https://www.rfc-editor.org/rfc/rfc9380.html#section-6.6.3
    class SSWUAB0
      attr_reader :sswu, :iso

      # Constructor
      # @param [H2C::M2C::Isogeny] iso
      # @param [Integer] z
      def initialize(iso, z)
        @sswu = SSWU.new(iso.e0, z)
        @iso = iso
      end

      # https://www.rfc-editor.org/rfc/rfc9380.html#section-6.6.3
      # @param [Integer] u
      # @return [ECDSA::Point]
      def map(u)
        p = sswu.map(u)
        coordinate = iso.map(p.x, p.y)
        iso.e1.new_point(coordinate)
      end
    end
  end
end
