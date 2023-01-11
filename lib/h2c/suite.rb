# frozen_string_literal: true
module H2C
  # Hash to curve suites
  class Suite

    attr_reader :id, :curve, :k, :exp, :m, :l, :ro

    Secp256k1_XMDSHA256_SSWU_NU_ = "secp256k1_XMD:SHA-256_SSWU_NU_"
    Secp256k1_XMDSHA256_SSWU_RO_ = "secp256k1_XMD:SHA-256_SSWU_RO_"

    # Initialize suite
    # @param [String] id Suite id.
    # @param [String] dst Domain separation tag.
    def initialize(id, dst)
      @id = id
      case id
      when Secp256k1_XMDSHA256_SSWU_NU_
        @curve = ECDSA::Group::Secp256k1
        @k = 128
        @exp = Expander.get(HashFunc::SHA256, dst, @k)
        @m = 1
        @l = 48
        @ro = false
      when Secp256k1_XMDSHA256_SSWU_RO_
        @curve = ECDSA::Group::Secp256k1
        @k = 128
        @exp = Expander.get(HashFunc::SHA256, dst, @k)
        @m = 1
        @l = 48
        @ro = true
      else
        raise H2C::Error, "suite #{suite} unsupported."
      end
    end

  end
end
