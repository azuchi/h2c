# frozen_string_literal: true
module ECDSA
  class Group
    Secp256k1_3ISO =
      new(
        name: "secp256k1_3ISO",
        p:
          0xFFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFE_FFFFFC2F,
        a: 0x3f8731abdd661adca08a5558f0f5d272e953d363cb6f0e5d405447c01a444533,
        b: 1771,
        g: [
          0xa677f67dec3b4e958267664f4bead0c300959b89cdfae2fbb7563af10a26088a,
          0xb683b56744d1140cbda41b9853bb2fb7cc44b06dc61406db73c387aea4e680d3
        ],
        n:
          0xFFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFE_BAAEDCE6_AF48A03B_BFD25E8C_D0364141,
        h: 1
      )
  end
end
