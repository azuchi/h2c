# frozen_string_literal: true

module H2C
  module M2C
    # https://www.ietf.org/archive/id/draft-irtf-cfrg-hash-to-curve-16.html#section-6.6.2
    class SSWU
      attr_reader :curve, :c1, :c2, :z

      # Constructor
      # @param [ECDSA::Group] curve
      # @param [Integer] z
      def initialize(curve, z)
        @curve = curve
        @z = z
        f = curve.field
        @c1 = f.mod(-curve.param_b * f.inverse(curve.param_a))
        @c2 = f.mod(-f.inverse(z))
      end

      # Outputs x and y are elements of the field F.
      # @param [Integer] u
      # @return [Array(Integer, Integer)] x and y
      def map(u)
        f = curve.field
        t1 = f.mod(f.power(u, 2) * f.mod(z))
        t2 = f.power(t1, 2)
        x1 = f.mod(t1 + t2)
        x1 = f.inverse(x1)
        e1 = x1.zero?
        x1 = f.mod(x1 + 1)
        x1 = e1 ? c2 : x1
        x1 = f.mod(x1 * c1)
        gx1 = f.power(x1, 2)
        gx1 = f.mod(gx1 + curve.param_a)
        gx1 = f.mod(gx1 * x1)
        gx1 = f.mod(gx1 + curve.param_b)
        x2 = f.mod(t1 * x1)
        t2 = f.mod(t1 * t2)
        gx2 = f.mod(gx1 * t2)
        e2 = square?(gx1)
        x = e2 ? x1 : x2
        y2 = e2 ? gx1 : gx2
        y = f.square_roots(y2)[0]
        e3 = sgn0(u) == sgn0(y)
        y = f.mod(e3 ? y : -y)
        curve.new_point([x, y])
      end

      def square?(x)
        test = curve.field.power(x, ((curve.field.prime - 1) / 2))
        [0, 1].include?(test)
      end

      def sgn0(x)
        res = x % 2
        curve.field.mod(1 - 2 * res)
      end
    end
  end
end
