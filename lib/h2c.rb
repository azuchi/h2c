# frozen_string_literal: true

require_relative "h2c/version"
require "ffi"

# Hash to Curves library.
# https://www.ietf.org/archive/id/draft-irtf-cfrg-hash-to-curve-16.html
module H2C
  autoload :FFI, "h2c/ffi"

  class Error < StandardError
  end
  # Your code goes here...
end
