# frozen_string_literal: true
require "digest"

module H2C
  module Expander
    # Expander::XML produces a uniformly random byte string using a cryptographic hash function H that outputs b bits.
    class XMD
      attr_reader :dst, :digest
      # Constructor
      # @param [String] func Hash function name. Currently supported by 'SHA256' and 'SHA512'
      # @param [String] dst Domain separation tag with binary format.
      # @raise [H2C::Error] If invalid func specified.
      def initialize(func, dst)
        @dst = dst
        @digest =
          case func
          when HashFunc::SHA256
            Digest(HashFunc::SHA256).new
          when HashFunc::SHA512
            Digest(HashFunc::SHA512).new
          else
            raise H2C::Error, "func #{func} is unsupported."
          end
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
        dst_prime = construct_dst_prime

        if ell >= 0xff || len >= 0xffff || dst_prime.bytesize >= 0xff
          raise H2C::Error, "requested too many bytes"
        end
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
        (2..(ell + 1)).each do |i|
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
