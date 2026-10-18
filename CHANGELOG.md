# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project aims to adhere to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

- Updated metadata source file to v9.0.41
- `PhoneNumberDescription.possible_lengths` no longer includes the lengths that are only possible when dialling locally, which are in the new `local_only_lengths`, and `Validation.is_possible_number_with_reason?/1` returns `:is_possible_local_only` for those lengths. `is_possible_number?/1` still accepts them.

### Fixed

- Strip the whitespace from `nationalPrefixForParsing`, so national prefixes are removed from AR and BR numbers (e.g. "011 15 2345-6789" in AR is +54 9 11 2345-6789)
- Split numbers at byte offsets rather than grapheme offsets, so text with multibyte characters before the number, an extension, a second number or an ISDN subaddress no longer drops or adds digits (e.g. "Tél. 650 253 0000" parsed as 502530000)
- Don't strip a national prefix when that would leave a number that's only possible when dialling locally, as libphonenumber does (e.g. "0123456" in GB keeps its 0)
- Count leading zeros as libphonenumber does, so a number with several leading zeros that ends in 0 keeps them all (e.g. "0010" in AU)
- Keep a compiled pattern's options when matching a whole string, so Unicode patterns match characters rather than bytes: letters between the digits make a number invalid (e.g. "650ä2530000"), and full-width extension labels are recognised (e.g. "650 253 0000 ｅｘｔ 12")

## [0.4.11] - 2026-03-18

### Added

- Allow configuring a custom metadata XML file path via `config :ex_phone_number, :metadata_file`

### Changed

- Updated metadata source file to v9.0.26
- Updated ex_doc to 0.40.1

## [0.4.10] - 2025-10-18

### Added

- LLM integration support with usage-rules.md
- Maintenance guide for library maintainers

## [0.4.9] - 2025-10-18

### Changed

- Updated metadata source file to v9.0.16

## [0.4.8] - 2025-06-28

### Changed

- No longer store regexes in module attributes for compatibility with OTP 28

## [0.4.7] - 2025-06-24

### Changed

- Updated metadata source file to v9.0.8

## [0.4.6] - 2025-06-22

### Removed

- Drop support for Elixir < 1.14

### Added

- Make `country_code_to_region_code_map` public
- Add type to PhoneNumber model

### Changed

- Spec phone number types

## [0.4.5] - 2024-09-16

### Changed

- Updated metadata source file to v8.13.45

## [0.4.4] - 2024-03-09

### Changed

- Updated metadata source file to v8.13.31

## [0.4.3] - 2023-08-25

### Changed

- Updated metadata source file to v8.13.19
- Require Elixir v1.11+

## [0.4.2] - 2023-05-22

### Changed

- Updated metadata source file to v8.13.12

## [0.4.1] - 2023-04-24

### Fixed

- Stop failing if Tesla is not in the dependencies

## [0.4.0] - 2023-04-18

Require Elixir v1.10+.

### Changed

- Updated metadata source file to v8.13.8

## [0.3.0] - 2022-06-17

### Changed

- Changed `sweet_xml` version requirement to `~> 0.7`

[unreleased]: https://github.com/ex-phone-number/ex_phone_number/compare/v0.4.11...HEAD
[0.4.11]: https://github.com/ex-phone-number/ex_phone_number/compare/v0.4.10..v0.4.11
[0.4.10]: https://github.com/ex-phone-number/ex_phone_number/compare/v0.4.9..v0.4.10
[0.4.9]: https://github.com/ex-phone-number/ex_phone_number/compare/v0.4.8..v0.4.9
[0.4.8]: https://github.com/ex-phone-number/ex_phone_number/compare/v0.4.7..v0.4.8
[0.4.7]: https://github.com/ex-phone-number/ex_phone_number/compare/v0.4.6..v0.4.7
[0.4.6]: https://github.com/ex-phone-number/ex_phone_number/compare/v0.4.5..v0.4.6
[0.4.5]: https://github.com/ex-phone-number/ex_phone_number/compare/v0.4.4...v0.4.5
[0.4.4]: https://github.com/ex-phone-number/ex_phone_number/compare/v0.4.3...v0.4.4
[0.4.3]: https://github.com/ex-phone-number/ex_phone_number/compare/v0.4.2...v0.4.3
[0.4.2]: https://github.com/ex-phone-number/ex_phone_number/compare/v0.4.1...v0.4.2
[0.4.1]: https://github.com/ex-phone-number/ex_phone_number/compare/v0.4.0...v0.4.1
[0.4.0]: https://github.com/ex-phone-number/ex_phone_number/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/ex-phone-number/ex_phone_number/compare/v0.2.1...v0.3.0
