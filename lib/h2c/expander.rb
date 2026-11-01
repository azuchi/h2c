# frozen_string_literal: true

module H2C
  # Expander allows to generate a pseudo-random byte string of a determined length.
  module Expander
    autoload :XMD, "h2c/expander/xmd"

    # Maximum allowed length for domain separation tags.
    MAX_DST_LENGTH = 255

    LONG_DST_PREFIX = [
      0x48,
      0x32,
      0x43,
      0x2d,
      0x4f,
      0x56,
      0x45,
      0x52,
      0x53,
      0x49,
      0x5a,
      0x45,
      0x2d,
      0x44,
      0x53,
      0x54,
      0x2d
    ].pack("C*")

    module_function

    # Get expander implementation
    # @param [String] func Hash function name. One of H2C::HashFunc::XMD_FUNCS
    # ("SHA256", "SHA384" or "SHA512").
    # @param [String] dst Domain separation tag with binary format. Must not be empty.
    # @raise [H2C::Error] If invalid func or empty dst specified.
    # @return [XMD] expander implementation, currently only XMD is supported.
    def get(func, dst, _k)
      unless HashFunc::XMD_FUNCS.include?(func)
        raise H2C::Error, "func #{func} is unsupported."
      end
      # RFC 9380 3.1 requires domain separation tags to have nonzero length.
      raise H2C::Error, "dst must not be empty." if dst.nil? || dst.empty?
      XMD.new(func, dst)
      # TODO: expand_message_xof for HashFunc::XOF_FUNCS is not implemented yet.
    end

    # XOR two byte(+x+ and +y+) string.
    # @param [String] x byte strings
    # @param [String] y byte strings
    # @return [String] xored byte strings
    def xor(x, y)
      x_bytes = x.unpack("C*")
      y_bytes = y.unpack("C*")
      x_bytes.zip(y_bytes).map { |a, b| a ^ b }.pack("C*")
    end
  end
end
