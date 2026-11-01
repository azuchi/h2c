# frozen_string_literal: true
module H2C
  module M2C
    # https://www.rfc-editor.org/rfc/rfc9380.html#appendix-E
    module Isogeny
      autoload :Secp256k1, "h2c/m2c/isogeny/secp256k1"
      autoload :BLS12381G1, "h2c/m2c/isogeny/bls12381_g1"
    end
  end
end
