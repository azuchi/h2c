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

  describe "#expand" do
    # RFC 9380 5.3.1 aborts only when ell > 255, len_in_bytes > 65535 or
    # len(DST) > 255. The checks used to be off by one and to look at
    # DST_prime (one byte longer than the dst), rejecting valid inputs.
    context "with output length at the limit" do
      let(:exp) { described_class.get(H2C::HashFunc::SHA256, "dst", 128) }

      it "accepts ell == 255" do
        len = 255 * 32
        expect(exp.expand("abc", len).bytesize).to eq(len)
      end

      it "rejects ell > 255" do
        expect { exp.expand("abc", 255 * 32 + 1) }.to raise_error(
          H2C::Error,
          /requested too many bytes/
        )
      end

      it "rejects len > 65535" do
        exp = described_class.get(H2C::HashFunc::SHA512, "dst", 128)
        expect { exp.expand("abc", 65_536) }.to raise_error(
          H2C::Error,
          /requested too many bytes/
        )
      end
    end

    context "with a dst of 254 or 255 bytes" do
      it "accepts the dst without hashing it" do
        [254, 255].each do |n|
          dst = "a" * n
          exp = described_class.get(H2C::HashFunc::SHA256, dst, 128)
          expect(exp.construct_dst_prime).to eq(dst + [n].pack("C"))
          expect(exp.expand("abc", 32).bytesize).to eq(32)
        end
      end
    end

    # A UTF-8 dst with non-ASCII characters used to raise
    # Encoding::CompatibilityError when its length byte was 0x80 or above,
    # because the tag was concatenated with a binary string.
    context "with a non-ASCII UTF-8 dst" do
      let(:dst) { "日" * 50 } # 150 bytes

      it "produces the same output as the equivalent binary dst" do
        utf8 = described_class.get(H2C::HashFunc::SHA256, dst, 128)
        binary = described_class.get(H2C::HashFunc::SHA256, dst.b, 128)

        expect(utf8.construct_dst_prime).to eq(dst.b + [150].pack("C"))
        expect(utf8.expand("abc", 32)).to eq(binary.expand("abc", 32))
      end
    end
  end
end
