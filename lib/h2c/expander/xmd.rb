# frozen_string_literal: true
require "digest"

module H2C
  module Expander
    # Expander::XMD produces a uniformly random byte string using a cryptographic hash function H that outputs b bits.
    class XMD
      attr_reader :dst, :digest

      # Constructor
      # @param [String] func Hash function name. Currently supported by 'SHA256', 'SHA384' and 'SHA512'
      # @param [String] dst Domain separation tag with binary format.
      def initialize(func, dst)
        # Concatenating with the length byte (and the hashed prefix for long
        # tags) requires a binary string. A UTF-8 tag with non-ASCII characters
        # would otherwise raise Encoding::CompatibilityError once the length
        # byte is 0x80 or above.
        @dst = dst.b
        # Keep the Digest class rather than an instance so that expand holds no
        # mutable state and a single expander can be shared across threads.
        @digest = Digest(func)
      end

      # Expand message.
      # https://www.rfc-editor.org/rfc/rfc9380.html#section-5.3.1
      # @param [String] msg The message to be expanded with binary format.
      # @param [Integer] len The length of the requested output in bytes.
      # @return [String] Expanded message.
      # @raise [H2C::Error]
      def expand(msg, len)
        b_len = digest.new.digest_length
        ell = (len + b_len - 1) / b_len
        # RFC 9380 5.3.1 step 2. A dst longer than 255 bytes has already been
        # hashed down by construct_dst_prime, so only the output length needs
        # checking here.
        if ell > 255 || len > 65_535
          raise H2C::Error,
                "requested too many bytes: len must be at most 65535 and " \
                  "ceil(len / #{b_len}) at most 255."
        end
        dst_prime = construct_dst_prime
        lib_str = [len].pack("n")
        z_pad = "\x00".b * digest.new.block_length

        b0 = digest.digest(z_pad + msg.b + lib_str + "\x00".b + dst_prime)
        bi = digest.digest(b0 + "\x01".b + dst_prime)
        pseudo = bi.dup
        # b_1 is already computed above, so this yields b_1, ..., b_ell in total.
        (2..ell).each do |i|
          bi = digest.digest(Expander.xor(b0, bi) + [i].pack("C") + dst_prime)
          pseudo << bi
        end
        pseudo[0, len]
      end

      # Construct DST prime.
      # https://www.rfc-editor.org/rfc/rfc9380.html#section-5.3.3
      # @return [String] DST prime
      def construct_dst_prime
        dst_prime =
          if dst.bytesize > MAX_DST_LENGTH
            digest.digest(LONG_DST_PREFIX + dst)
          else
            dst
          end
        dst_prime + [dst_prime.bytesize].pack("C")
      end
    end
  end
end
