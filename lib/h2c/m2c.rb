# frozen_string_literal: true

module H2C
  # Map to Curve functions.
  # https://www.ietf.org/archive/id/draft-irtf-cfrg-hash-to-curve-16.html#section-6
  module M2C
    autoload :ISOGeny, "h2c/m2c/isogeny"
    autoload :SSWU, "h2c/m2c/sswu"
    autoload :SSWUAB0, "h2c/m2c/sswuab0"
  end
end
