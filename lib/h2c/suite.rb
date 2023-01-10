# frozen_string_literal: true
module H2C
  # Hash to curve suites
  class Suite

    attr_reader :id, :curve, :k, :exp, :m, :l, :ro


    Secp256k1_XMDSHA256_SSWU_NU_ = "secp256k1_XMD:SHA-256_SSWU_NU_"
    Secp256k1_XMDSHA256_SSWU_RO_ = "secp256k1_XMD:SHA-256_SSWU_RO_"

    # Get suite
    # @param [String] id Suite id.
    # @param [String] dst Domain separation tag.
    # @return [H2C::Suite]
    def self.get(id, dst)
      case id
      when Secp256k1_XMDSHA256_SSWU_NU_
        Suite.new(id: id, curve: ECDSA::Group::Secp256k1, k: 128, hash_func: HashFunc::SHA256, dst: dst, m: 1, l: 48, ro: false)
      when Secp256k1_XMDSHA256_SSWU_RO_
        Suite.new(id: id, curve: ECDSA::Group::Secp256k1, k: 128, hash_func: HashFunc::SHA256, dst: dst, m: 1, l: 48, ro: true)
      else
        raise H2C::Error, "suite #{suite} unsupported."
      end
    end

    def initialize(id:, curve:, k:, hash_func:, m:, l:, ro:, dst:)
      @id = id
      @curve = curve
      @exp = Expander.get(hash_func, dst, k)
      @m = m
      @l = l
      @k = k
      @ro = ro
    end

  end
end
