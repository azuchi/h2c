# frozen_string_literal: true

require "spec_helper"

RSpec.describe H2C::HashToPoint do
  describe "Test Vector" do
    dir_path = File.join(File.dirname(__FILE__), "..", "fixtures", "suites")
    Dir.each_child(dir_path) do |f|
      describe f do
        it do
          v = JSON.parse(File.read(File.join(dir_path, [f])))
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
  end
end
