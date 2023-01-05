# frozen_string_literal: true

require_relative "h2c/version"

# Hash to Curves library.
# https://www.ietf.org/archive/id/draft-irtf-cfrg-hash-to-curve-16.html
module H2C
  class Error < StandardError
  end

  autoload :Expander, "h2c/expander"
end
