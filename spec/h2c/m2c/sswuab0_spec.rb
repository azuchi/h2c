# frozen_string_literal: true

require "spec_helper"

RSpec.describe H2C::M2C::SSWUAB0 do
  # SSWUAB0 delegates to SSWU on the isogenous curve, so it inherits the
  # exceptional case described in spec/h2c/m2c/sswu_spec.rb. The resulting point
  # must land on the target curve after the isogeny is applied.
  isogenies = {
    "secp256k1" => [H2C::M2C::ISOGeny::Secp256k1, -11],
    "BLS12381G1" => [H2C::M2C::ISOGeny::BLS12381G1, 11]
  }

  describe "#map" do
    context "with the exceptional case" do
      isogenies.each do |name, (iso_class, z)|
        it "maps u = 0 onto #{name}" do
          iso = iso_class.new
          point = described_class.new(iso, z).map(0)

          expect(iso.e1.partially_valid_public_key?(point)).to be true
        end

        it "maps u satisfying Z * u^2 == -1 onto #{name}" do
          iso = iso_class.new
          map = described_class.new(iso, z)
          field = iso.e0.field
          roots = field.square_roots(field.mod(-field.inverse(field.mod(z))))
          expect(roots.size).to eq(2)

          roots.each do |u|
            expect(iso.e1.partially_valid_public_key?(map.map(u))).to be true
          end
        end
      end
    end
  end
end
