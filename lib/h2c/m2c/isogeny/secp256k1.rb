# frozen_string_literal: true
module H2C
  module M2C
    module ISOGeny
      # 3-isogeny map for secp256k1
      # https://www.ietf.org/archive/id/draft-irtf-cfrg-hash-to-curve-16.html#appendix-E.1
      class Secp256k1
        attr_reader :e0, :e1

        X_NUM = [
          0x8e38e38e38e38e38e38e38e38e38e38e38e38e38e38e38e38e38e38daaaaa8c7,
          0x7d3d4c80bc321d5b9f315cea7fd44c5d595d2fc0bf63b92dfff1044f17c6581,
          0x534c328d23f234e6e2a413deca25caece4506144037c40314ecbd0b53d9dd262,
          0x8e38e38e38e38e38e38e38e38e38e38e38e38e38e38e38e38e38e38daaaaa88c
        ].freeze
        X_DEN = [
          0xd35771193d94918a9ca34ccbb7b640dd86cd409542f8487d9fe6b745781eb49b,
          0xedadc6f64383dc1df7c4b2d51b54225406d36b641f5e41bbc52a56612a8c6d14,
          1,
          0
        ].freeze
        Y_NUM = [
          0x4bda12f684bda12f684bda12f684bda12f684bda12f684bda12f684b8e38e23c,
          0xc75e0c32d5cb7c0fa9d0a54b12a0a6d5647ab046d686da6fdffc90fc201d71a3,
          0x29a6194691f91a73715209ef6512e576722830a201be2018a765e85a9ecee931,
          0x2f684bda12f684bda12f684bda12f684bda12f684bda12f684bda12f38e38d84
        ].freeze
        Y_DEN = [
          0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffefffff93b,
          0x7a06534bb8bdb49fd5e9e6632722c2989467c1bfc8e8d978dfb425d2685c2573,
          0x6484aa716545ca2cf3a70c3fa8fe337e0a3d21162f0d6299a7bf8192bfd2a76f,
          1
        ].freeze

        def initialize
          @e0 = ECDSA::Group::Secp256k1_3ISO
          @e1 = ECDSA::Group::Secp256k1
        end

        def map(x, y)
          f = e0.field

          x_num = 0
          x_den = 0
          y_num = 0
          y_den = 0
          3.step(0, -1) do |i|
            x_num = f.mod(x_num * x + X_NUM[i])
            x_den = f.mod(x_den * x + X_DEN[i])
            y_num = f.mod(y_num * x + Y_NUM[i])
            y_den = f.mod(y_den * x + Y_DEN[i])
          end
          xx = f.mod(x_num * f.inverse(x_den))
          yy = f.mod(y * (y_num * f.inverse(y_den)))
          [xx, yy]
        end
      end
    end
  end
end
