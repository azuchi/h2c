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
            # len = t['len_in_bytes'].hex
            # result = exp.expand(t['msg'], len)
            # expect(result).to eq([t['uniform_bytes']].pack('H*'))
          end
        end
      end
    end
  end
end
