# frozen_string_literal: true

module H2C
  # Curve definitions used by the suites that are not provided by the ecdsa gem,
  # including the isogenous curves required by the SSWU map for AB == 0 curves.
  module Curve
  end
end

require_relative "curve/secp256k1_3iso"
require_relative "curve/bls12381_g1"
require_relative "curve/bls12381_g1_11iso"
