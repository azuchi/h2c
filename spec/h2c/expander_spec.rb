# frozen_string_literal: true

require "spec_helper"

RSpec.describe H2C::Expander do
  describe "Test Vector" do
    dir_path = File.join(File.dirname(__FILE__), "..", "fixtures", "expander")
    Dir.each_child(dir_path) do |f|
      v = JSON.parse(File.read(File.join(dir_path, [f])))
      describe f do
        it do
          exp = described_class.get(v["hash"], v["DST"], v["k"])
          v["tests"].each do |t|
            expect(exp.construct_dst_prime.unpack1("H*")).to eq(t["DST_prime"])
            len = t["len_in_bytes"].hex
            result = exp.expand(t["msg"], len)
            expect(result).to eq([t["uniform_bytes"]].pack("H*"))
          end
        end
      end
    end
  end

  describe ".get" do
    context "with an unsupported func" do
      it do
        expect { described_class.get("MD5", "dst", 128) }.to raise_error(
          H2C::Error,
          "func MD5 is unsupported."
        )
      end
    end

    # RFC 9380 3.1 requires domain separation tags to have nonzero length.
    context "with an empty dst" do
      it do
        expect do
          described_class.get(H2C::HashFunc::SHA256, "", 128)
        end.to raise_error(H2C::Error, "dst must not be empty.")
      end
    end

    context "with a nil dst" do
      it do
        expect do
          described_class.get(H2C::HashFunc::SHA256, nil, 128)
        end.to raise_error(H2C::Error, "dst must not be empty.")
      end
    end
  end
end
