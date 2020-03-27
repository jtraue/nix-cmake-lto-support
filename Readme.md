This project reproduces a CMake problem in nix builds with LTO.

In order to enable LTO, CMake's internal `CheckIPOSupported` module is
used to figure out whether the compiler supports the feature.

This is fine for a build using gcc:
`nix-build -A projectGcc`

It breaks for Clang:
`nix-build -A projectClang`

But only because of LTO. If it is disabled, the clang build is fine:
`nix-build -A projectClang --arg enableLTO false`
