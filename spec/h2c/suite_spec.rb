# frozen_string_literal: true

require "spec_helper"

RSpec.describe H2C::Suite do
  describe "#initialize" do
    context "with an unsupported suite" do
      it "names the offending suite id" do
        id = "Curve25519_XMD:SHA-512_ELL2_RO_"

        expect { described_class.new(id, "dst") }.to raise_error(
          H2C::Error,
          "suite #{id} unsupported."
        )
      end
    end

    # The dst is validated by Expander.get, which every suite goes through.
    context "with an empty dst" do
      it do
        expect do
          described_class.new(H2C::Suite::SECP256K1_XMDSHA256_SSWU_RO_, "")
        end.to raise_error(H2C::Error, "dst must not be empty.")
      end
    end
  end
end
