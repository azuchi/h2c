# frozen_string_literal: true
require "digest"

module H2C
  module Expander
    # Expander::XMD produces a uniformly random byte string using a cryptographic hash function H that outputs b bits.
    class XMD
      attr_reader :dst, :digest
      # Constructor
      # @param [String] func Hash function name. Currently supported by 'SHA256' and 'SHA512'
      # @param [String] dst Domain separation tag with binary format.
      def initialize(func, dst)
        # Concatenating with the length byte (and the hashed prefix for long
        # tags) requires a binary string. A UTF-8 tag with non-ASCII characters
        # would otherwise raise Encoding::CompatibilityError once the length
        # byte is 0x80 or above.
        @dst = dst.b
        @digest = Digest(func).new
      end

      # Expand message.
      # https://www.ietf.org/archive/id/draft-irtf-cfrg-hash-to-curve-16.html#name-expand_message_xmd
      # @param [String] msg The message to be expanded with binary format.
      # @param [Integer] len The length of the requested output in bytes.
      # @return [String] Expanded message.
      # @raise [H2C::Error]
      def expand(msg, len)
        b_len = digest.digest_length
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
        lib_str = [(len >> 8) & 0xFF, (len & 0xff)].pack("CC")
        z_pad = Array.new(digest.block_length, 0)

        digest.reset
        digest.update(z_pad.pack("C*"))
        digest.update(msg)
        digest.update(lib_str)
        digest.update([0].pack("C"))
        digest.update(dst_prime)

        b0 = digest.digest
        digest.reset
        digest.update(b0)
        digest.update([1].pack("C"))
        digest.update(dst_prime)

        bi = digest.digest
        pseudo = bi
        # b_1 is already computed above, so this yields b_1, ..., b_ell in total.
        (2..ell).each do |i|
          digest.reset
          digest.update(Expander.xor(b0, bi))
          digest.update([i].pack("C"))
          digest.update(dst_prime)
          bi = digest.digest
          pseudo += bi
        end
        pseudo[0...len]
      end

      # Construct DST prime.
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
