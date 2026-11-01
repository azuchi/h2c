# frozen_string_literal: true

require_relative "h2c/version"
require "ecdsa"
require_relative "h2c/curve"

# Hash to Curves library.
# https://www.rfc-editor.org/rfc/rfc9380.html
module H2C
  class Error < StandardError
  end

  autoload :Expander, "h2c/expander"
  autoload :Suite, "h2c/suite"
  autoload :HashToPoint, "h2c/hash_to_point"
  autoload :M2C, "h2c/m2c"

  # Hash function name
  module HashFunc
    SHA256 = "SHA256"
    SHA384 = "SHA384"
    SHA512 = "SHA512"
    SHAKE128 = "SHAKE128"
    SHAKE256 = "SHAKE256"

    XMD_FUNCS = [SHA256, SHA384, SHA512].freeze
    XOF_FUNCS = [SHAKE128, SHAKE256].freeze
  end

  module_function

  # Get hash to curve corresponding to +suite+.
  #
  # @param [String] suite Suite id for hashing. See the constants in H2C::Suite
  # for the supported suites.
  # @param [String] dst Domain separation tag. Must not be empty.
  # @raise [H2C::Error] If the suite is unsupported or dst is empty.
  # @return [H2C::HashToPoint]
  def get(suite, dst)
    suite = Suite.new(suite, dst)
    HashToPoint.new(suite)
  end
end
