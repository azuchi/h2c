# frozen_string_literal: true

require "spec_helper"

RSpec.describe H2C::M2C::SSWU do
  # The simplified SWU map has an exceptional case at Z * u^2 + (Z * u^2)^2 == 0,
  # reached when u == 0 or Z * u^2 == -1. RFC 9380 6.6.2 step 4 relies on inv0,
  # which maps 0 to 0 instead of raising, and step 7 then selects x1 = B / (Z * A).
  # https://www.rfc-editor.org/rfc/rfc9380.html#section-6.6.2
  curves = {
    "P256" => [ECDSA::Group::Nistp256, -10],
    "P384" => [ECDSA::Group::Nistp384, -12],
    "P521" => [ECDSA::Group::Nistp521, -4]
  }

  describe "#map" do
    # sgn0 depends on the parity of u, so an unreduced u (u >= p or u < 0)
    # must be reduced first or the sign of y flips.
    context "with an unreduced u" do
      it "maps u and u + p to the same point" do
        group = ECDSA::Group::Nistp256
        map = described_class.new(group, -10)
        u = 5

        expect(map.map(u + group.field.prime)).to eq(map.map(u))
        expect(map.map(u - group.field.prime)).to eq(map.map(u))
      end
    end

    context "with the exceptional case" do
      curves.each do |name, (group, z)|
        it "maps u = 0 to B / (Z * A) on #{name}" do
          field = group.field
          expected =
            field.mod(
              group.param_b * field.inverse(field.mod(z * group.param_a))
            )

          point = described_class.new(group, z).map(0)

          expect(point.x).to eq(expected)
          expect(group.partially_valid_public_key?(point)).to be true
        end

        it "maps u satisfying Z * u^2 == -1 onto #{name}" do
          field = group.field
          map = described_class.new(group, z)
          roots = field.square_roots(field.mod(-field.inverse(field.mod(z))))
          expect(roots.size).to eq(2)

          roots.each do |u|
            expect(group.partially_valid_public_key?(map.map(u))).to be true
          end
        end
      end
    end
  end
end
