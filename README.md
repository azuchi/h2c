# Hashing to Elliptic Curves for Ruby

This is a Ruby implementation of the [Hash to Curves](https://github.com/cfrg/draft-irtf-cfrg-hash-to-curve) proposed by the [IETF](https://datatracker.ietf.org/doc/draft-irtf-cfrg-hash-to-curve/).

It has been tested using the Test Vector provided, but the code has not been audited to ensure functional specification and safety. Also It is under development and is subject to change without backward compatibility.

## Security considerations

**This library is not constant-time and must not be used with secret input messages.**

[RFC 9380 Section 4](https://www.rfc-editor.org/rfc/rfc9380.html#section-4) requires a constant-time implementation when the message being hashed is secret. This library does not meet that requirement:

* Field arithmetic is performed with Ruby's arbitrary-precision `Integer`, whose execution time depends on the operand values.
* The mapping in `H2C::M2C::SSWU#map` selects between candidates with ordinary `if`/ternary branches rather than constant-time conditional moves.
* Byte-string handling in `H2C::Expander` allocates and copies in ways that depend on the requested length.

An attacker able to measure timing or cache behaviour may therefore be able to recover information about the input. Hashing a **public** message to a curve point (the primary use case of RFC 9380) is unaffected.

In particular, do not use this library to derive nonces or key material directly from secret values — for example, FROST's `nonce_generate`, which hashes a secret share. Such protocols require a constant-time implementation.

Additionally, `H2C::HashToPoint` and the `H2C::Expander` instance it holds keep mutable digest state, so a single instance must not be shared across threads. Create one instance per thread instead.

The following cipher suites are currently supported:

* secp256k1_XMD:SHA-256_SSWU_NU_
* secp256k1_XMD:SHA-256_SSWU_RO_
* BLS12381G1_XMD:SHA-256_SSWU_NU_
* BLS12381G1_XMD:SHA-256_SSWU_RO_
* P256_XMD:SHA-256_SSWU_NU_
* P256_XMD:SHA-256_SSWU_RO_
* P384_XMD:SHA-384_SSWU_NU_
* P384_XMD:SHA-384_SSWU_RO_
* P521_XMD:SHA-512_SSWU_NU_
* P521_XMD:SHA-512_SSWU_RO_

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'h2c'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install h2c

## Usage

```ruby
require 'h2c'

dst = "QUUX-V01-CS02-with-secp256k1_XMD:SHA-256_SSWU_RO_"

h2c = H2C.get(H2C::Suite::SECP256K1_XMDSHA256_SSWU_RO_, dst)

msg = "abc"

result = h2c.digest(msg)
puts result.inspect
#<ECDSA::Point: secp256k1, 0x3377e01eab42db296b512293120c6cee72b6ecf9f9205760bd9ff11fb3cb2c4b, 0x7f95890f33efebd1044d382a01b1bee0900fb6116f94688d487c6c7b9c8371f6>
```
