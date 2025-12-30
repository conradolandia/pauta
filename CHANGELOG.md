# Changelog

All notable changes to the `pauta` module will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2025.12.30] - 2025-12-30

### Added
- Automated installation script (`install-module.sh`) with version checking and conflict resolution
- Release creation script (`make-release.sh`) for generating TDS-compliant ZIP archives
- XML interface file (`t-pauta.xml`) for command documentation and editor support
- Added more `%D` documentation comments throughout the module source code
- `.gitignore` patterns for build artifacts (`.log`, `.tuc`, `.tuo`, `README-md-*.tex`)
- Improved support for custom header/footer content via `infoLeft` and `infoRight` parameters

### Changed
- **BREAKING**: Renamed `infoPosition` parameter values from `top`/`bottom` to `header`/`footer`
- Replaced external `hatching.mp` dependency with pure MetaFun implementation
- Improved module structure to fully comply with ConTeXt module writing guidelines
- Updated module header version to `2025.12.30`
- Enhanced README.md with installation instructions, development guidelines, and improved examples
- Standardized variable naming (e.g., `nibWidth` instead of `nibwidth`)

### Fixed
- Resolved MetaPost errors by removing dependency on `hatching.mp`
- Fixed MetaPost clipping mechanism in hatching implementation (using `image` blocks instead of direct `clip`)
- Corrected version comparison logic in installation script to prevent premature exit
- Updated documentation to reflect `header`/`footer` terminology instead of `top`/`bottom`

### Removed
- External `hatching.mp` library (functionality reimplemented in pure MetaFun)
- Build artifacts and temporary files from repository

### Technical
- Implemented custom `DrawHatching()` function using pure MetaFun
- All drawing operations now use native MetaPost without external dependencies
- Module now fully TDS-compliant with proper directory structure

## [2024.03.02] - 2024-03-02

### Added
- Initial release of the `pauta` module
- Basic calligraphy grid generation with customizable parameters
- Support for nib width marks and angle guides
- Header/footer information display for hand metadata
- Multiple configuration options (colors, spacing, dimensions)
- Example files and documentation

### Changed
- Converted from standalone script to ConTeXt module structure
- Improved code organization and modularity

---

## [Unreleased]

### Planned
- Proper reset of header/footer typesetting areas after module use
- Additional customization options
- Performance optimizations

---

[2025.12.30]: https://github.com/conradolandia/pauta/compare/v2024.03.02...v2025.12.30
[2024.03.02]: https://github.com/conradolandia/pauta/releases/tag/v2024.03.02
