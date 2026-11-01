# frozen_string_literal: true

require "spec_helper"

RSpec.describe H2C::HashToPoint do
  describe "Test Vector" do
    Dir.each_child(File.join(__dir__, "..", "fixtures", "suites")) do |f|
      describe f do
        it do
          v =
            JSON.parse(
              File.read(File.join(__dir__, "..", "fixtures", "suites", f))
            )
          h2c = H2C.get(v["ciphersuite"], v["dst"])
          v["vectors"].each do |t|
            p = h2c.digest(t["msg"])
            expect(p.x).to eq(t["P"]["x"].hex)
            expect(p.y).to eq(t["P"]["y"].hex)
            count = h2c.suite.ro ? 2 : 1
            u = h2c.hash_to_field(t["msg"], count)
            expect(u).to eq(t["u"].map(&:hex))
          end
        end
      end
    end
  end

  describe "hash to field" do
    context "with modulo" do
      it do
        dst = "FROST-secp256k1-SHA256-v1nonce"
        h2c = H2C.get(H2C::Suite::SECP256K1_XMDSHA256_SSWU_NU_, dst)
        msg = [
          "7ea5ed09af19f6ff21040c07ec2d2adbd35b759da5a401d4c99dd26b82391cb208f89ffe80ac94dcb920c26f3f46140bfc7f95b493f8310f5fc1ea2b01f4254c" # rubocop:disable all
        ].pack("H*")
        field = h2c.hash_to_field(msg, 1, ECDSA::Group::Secp256k1.order).first
        expect(field).to eq(
          0x841d3a6450d7580b4da83c8e618414d0f024391f2aeb511d7579224420aa81f0
        )
      end
    end

    # Every suite currently has m == 1, which hides an off-by-one in the way the
    # expanded message is split. Extension degrees of 2 or more must take a
    # disjoint l-byte window per element, as required by RFC 9380 5.2.
    context "with an extension degree of 2" do
      it "derives each element from its own l-byte window" do
        dst = "QUUX-V01-CS02-with-P256_XMD:SHA-256_SSWU_RO_"
        exp = H2C::Expander.get(H2C::HashFunc::SHA256, dst, 128)
        group = ECDSA::Group::Nistp256
        l = 48
        suite = instance_double(H2C::Suite, curve: group, m: 2, l: l, exp: exp)
        msg = "abc"

        u = described_class.new(suite).hash_to_field(msg, 2)

        pseudo = exp.expand(msg, 2 * 2 * l)
        expect(u).to eq(
          Array.new(4) do |i|
            pseudo[l * i, l].unpack1("H*").to_i(16) % group.field.prime
          end
        )
      end
    end
  end
end
