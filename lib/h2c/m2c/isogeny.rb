# frozen_string_literal: true
module H2C
  module M2C
    # https://www.ietf.org/archive/id/draft-irtf-cfrg-hash-to-curve-16.html#name-isogeny-maps-for-suites
    module ISOGeny
      autoload :Secp256k1, "h2c/m2c/isogeny/secp256k1"
    end
  end
end
