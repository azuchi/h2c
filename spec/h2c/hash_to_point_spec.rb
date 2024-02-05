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
            expect(u).to eq(t['u'].map(&:hex))
          end
        end
      end
    end
  end
end
