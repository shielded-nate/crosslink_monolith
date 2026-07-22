# Work-In-Progress Repo - Direct Vulnerability Work to Zebra!

This is a rapidly changing repository used for prototyping and testnets. In the future, we would like to receive thorough reviews by bug-hunting teams, but currently we would kindly ask that you direct your vulnerability discovery efforts to: https://github.com/zcashfoundation/zebra

# crosslink_monolith

A subtree'd monorepo for all crosslink code/dependencies

Note: all commands assume the current directory is the repo working tree root.

## Build Instructions

The monolith currently has no top-level build command. The documented build target is `zebrad` from the `zebra-crosslink` workspace:

```bash
cargo build --manifest-path zebra-crosslink/Cargo.toml --locked --package zebrad
```

`nix build` runs this same build process through the root `flake.nix`.

## Automated Test Instructions

The documented automated test processes are:

1. Zebrad library tests:

   ```bash
   cargo test --manifest-path zebra-crosslink/Cargo.toml --locked --package zebrad --lib
   ```

2. Zebrad config integration test:

   ```bash
   cargo test --manifest-path zebra-crosslink/Cargo.toml --locked --package zebrad --test config
   ```

`nix flake check` exposes and runs a distinct derivation for each of the two test commands above.

## Nix Development Shell

Run:

```bash
nix develop
```

This shell provides the toolchain and native dependencies needed for the documented non-Nix build and test commands.
