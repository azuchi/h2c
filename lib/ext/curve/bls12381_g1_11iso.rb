# frozen_string_literal: true
module BLS
  class Group
    BLS12381G1_11ISO =
      ECDSA::Group.new(
        name: "bls12381_g1_11iso",
        p:
          0x1a0111ea397fe69a4b1ba7b6434bacd764774b84f38512bf6730d2a0f6b0f6241eabfffeb153ffffb9feffffffffaaab,
        a:
          0x144698a3b8e9433d693a02c96d4982b0ea985383ee66a8d8e8981aefd881ac98936f8da0e0f97f5cf428082d584c1d,
        b:
          0x12e2908d11688030018b12e8753eee3b2016c1f0f24f4070a0b9c14fcef35ef55a23215a316ceaa5d1cc48e98e172be0,
        g: [
          0x6a0ead062ba73a09984eb7351a2d851bc817625345ce033a6eb7d78242b6466c877e022dda626a79ddb85bce57997e2,
          0x3b89d8bb9326270e46b6b74e19f7b3f10082fbf1a46df72da50c6571b969afc570d6529350b1b9b05ab4fe5c29920b4
        ],
        n: 0x73eda753299d7d483339d80809a1d80553bda402fffe5bfeffffffff00000001,
        h: 0xd201000000010001
      )
  end
end
