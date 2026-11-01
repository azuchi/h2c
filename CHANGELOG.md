## [Unreleased]

### Breaking changes

- Move the curve definitions from `ECDSA::Group::Secp256k1_3ISO`, `BLS::Group::BLS12381G1` and `BLS::Group::BLS12381G1_11ISO` to `H2C::Curve::Secp256k1_3ISO`, `H2C::Curve::BLS12381G1` and `H2C::Curve::BLS12381G1_11ISO`, so that h2c no longer defines constants in the ecdsa gem's namespace or a top-level `BLS` module.
- Require Ruby 3.3 or later, matching the versions tested in CI.
- `H2C::Expander::XMD#digest` now returns the `Digest` class rather than a shared instance, and `#dst` returns a binary (ASCII-8BIT) copy of the tag.

### Fixed

- `expand_message_xmd` raised `Encoding::CompatibilityError` for a UTF-8 DST containing non-ASCII characters whose length byte is 0x80 or above.
- `expand_message_xmd` rejected valid inputs: `ell == 255`, `len_in_bytes == 65535` and DSTs of 254 or 255 bytes. The abort conditions now follow RFC 9380 Section 5.3.1 exactly.
- `H2C::M2C::SSWU#map` reduces `u` modulo p before computing `sgn0`, so an unreduced `u` maps to the same point as `u mod p`.
- `H2C::M2C::SSWU#map` raises `H2C::Error` instead of `NoMethodError` when no square root is found.

### Changed

- `H2C::Expander::XMD` holds no mutable digest state, so an expander (and `H2C::HashToPoint`) can be shared across threads.
- Skip the cofactor multiplication when the cofactor is 1.
- Documentation now references RFC 9380 instead of draft-irtf-cfrg-hash-to-curve-16.

## [0.3.0] - 2026-08-09

- Fix the SSWU exceptional case (`u == 0` or `Z * u^2 == -1`) by using `inv0` semantics instead of raising.
- Fix the byte range used by `hash_to_field` when splitting the expanded message, which was wrong for extension degree `m > 1`.
- Reject an empty domain separation tag, as required by RFC 9380 Section 3.1.
- Document that the library is not constant-time and must not be used with secret inputs.
- Test against Ruby 3.3, 3.4 and 4.0.

## [0.2.1] - 2024-02-06

- Add a `modulo` argument to `H2C::HashToPoint#hash_to_field` so that protocols such as FROST can reduce by the group order.
- Move the BLS12-381 group definitions from `ECDSA::Group` to `BLS::Group`.

## [0.2.0] - 2023-01-13

- Support `BLS12381G1_XMD:SHA-256_SSWU_NU_` and `BLS12381G1_XMD:SHA-256_SSWU_RO_`.
- Support `P256_XMD:SHA-256_SSWU_NU_` and `P256_XMD:SHA-256_SSWU_RO_`.
- Support `P384_XMD:SHA-384_SSWU_NU_` and `P384_XMD:SHA-384_SSWU_RO_`.
- Support `P521_XMD:SHA-512_SSWU_NU_` and `P521_XMD:SHA-512_SSWU_RO_`.

## [0.1.0] - 2023-01-12

- Initial release with `secp256k1_XMD:SHA-256_SSWU_NU_` and `secp256k1_XMD:SHA-256_SSWU_RO_`.
