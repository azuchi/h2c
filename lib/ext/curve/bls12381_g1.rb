# frozen_string_literal: true
module BLS
  class Group
    BLS12381G1 =
      ECDSA::Group.new(
        name: "bls12381_g1",
        p:
          0x1a0111ea397fe69a4b1ba7b6434bacd764774b84f38512bf6730d2a0f6b0f6241eabfffeb153ffffb9feffffffffaaab,
        a: 0,
        b: 4,
        g: [
          0x17f1d3a73197d7942695638c4fa9ac0fc3688c4f9774b905a14e3a3f171bac586c55e83ff97a1aeffb3af00adb22c6bb,
          0x8b3f481e3aaa0f1a09e30ed741d8ae4fcf5e095d5d00af600db18cb2c04b3edd03cc744a2888ae40caa232946c5e7e1
        ],
        n: 0x73eda753299d7d483339d80809a1d80553bda402fffe5bfeffffffff00000001,
        h: 0xd201000000010001
      )
  end
end
