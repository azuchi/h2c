# Hashing to Elliptic Curves for Ruby

This is a Ruby implementation of the [Hash to Curves](https://github.com/cfrg/draft-irtf-cfrg-hash-to-curve) proposed by the [IETF](https://datatracker.ietf.org/doc/draft-irtf-cfrg-hash-to-curve/).

It has been tested using the Test Vector provided, but the code has not been audited to ensure functional specification and safety. Also It is under development and is subject to change without backward compatibility.

The following cipher suites are currently supported:

* secp256k1_XMD:SHA-256_SSWU_NU_
* secp256k1_XMD:SHA-256_SSWU_RO_
* BLS12381G1_XMD:SHA-256_SSWU_NU_
* BLS12381G1_XMD:SHA-256_SSWU_RO_

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
