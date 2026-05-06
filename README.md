# 🍺 Homebrew tap — Beeping Platform CLIs

Official Homebrew tap for the [Beeping Platform](https://github.com/beeping-io)
command-line tools.

## Install

```sh
brew install beeping-io/tap/beeping-cli
```

The first invocation auto-adds this tap. Equivalent to:

```sh
brew tap beeping-io/tap
brew install beeping-cli
```

## Available formulae

| Formula | Description | Source repo |
|---|---|---|
| `beeping-cli` | Official Rust CLI for the Beeping Platform — data over sound | [beeping-io/beeping-cli](https://github.com/beeping-io/beeping-cli) |

## How updates work

The canonical formula lives in
[`beeping-io/beeping-cli`](https://github.com/beeping-io/beeping-cli)
at `external/tap/Formula/beeping-cli.rb`. Each release automatically
syncs the SHA256 hashes here (BEE-1782, post-BEE-151 bootstrap).

**Direct edits to this repo will be overwritten** by the next release sync.
File changes upstream in the source-of-truth repo.

## Status

Bootstrapped 2026-05-06 by BEE-151. Formula uses placeholder SHA256 hashes
until the first `v0.0.x` tag of `beeping-cli` lands. Until then,
`brew install beeping-io/tap/beeping-cli` will fail with a hash mismatch —
expected.

## License

[Apache-2.0](LICENSE), matching the binaries it distributes.
