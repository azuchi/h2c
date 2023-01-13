# frozen_string_literal: true
module H2C
  # Hash to curve suites
  class Suite
    attr_reader :id, :curve, :k, :exp, :m, :l, :ro, :map

    SECP256K1_XMDSHA256_SSWU_NU_ = "secp256k1_XMD:SHA-256_SSWU_NU_"
    SECP256K1_XMDSHA256_SSWU_RO_ = "secp256k1_XMD:SHA-256_SSWU_RO_"
    BLS12381G1_XMDSHA256_SWU_NU_ = "BLS12381G1_XMD:SHA-256_SSWU_NU_"
    BLS12381G1_XMDSHA256_SWU_RO_ = "BLS12381G1_XMD:SHA-256_SSWU_RO_"
    BLS12381G2_XMDSHA256_SWU_NU_ = "BLS12381G2_XMD:SHA-256_SSWU_NU_"
    BLS12381G2_XMDSHA256_SWU_RO_ = "BLS12381G2_XMD:SHA-256_SSWU_RO_"

    # Initialize suite
    # @param [String] id Suite id.
    # @param [String] dst Domain separation tag.
    def initialize(id, dst)
      @id = id
      case id
      when SECP256K1_XMDSHA256_SSWU_NU_, SECP256K1_XMDSHA256_SSWU_RO_
        @curve = ECDSA::Group::Secp256k1
        @k = 128
        @exp = Expander.get(HashFunc::SHA256, dst, @k)
        @m = 1
        @l = 48
        @map = M2C::SSWUAB0.new(H2C::M2C::ISOGeny::Secp256k1.new, -11)
        @ro = (id == SECP256K1_XMDSHA256_SSWU_RO_)
      when BLS12381G1_XMDSHA256_SWU_NU_, BLS12381G1_XMDSHA256_SWU_RO_
        @curve = ECDSA::Group::BLS12381G1
        @k = 128
        @exp = Expander.get(HashFunc::SHA256, dst, @k)
        @m = 1
        @l = 64
        @map = M2C::SSWUAB0.new(H2C::M2C::ISOGeny::BLS12381G1.new, 11)
        @ro = (id == BLS12381G1_XMDSHA256_SWU_RO_)
      else
        raise H2C::Error, "suite #{curve} unsupported."
      end
    end
  end
end
