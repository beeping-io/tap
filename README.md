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

The canonical formula structure lives in
[`beeping-io/beeping-cli`](https://github.com/beeping-io/beeping-cli)
at `external/tap/Formula/beeping-cli.rb`. On every release of
`beeping-cli`:

1. Its `release.yml` builds + signs + publishes the binaries with
   `SHA256SUMS` (BEE-1780) + cosign + SBOM + SLSA L3 (BEE-1781).
2. It fires a `repository_dispatch` event to this repo with the new
   tag.
3. This repo's [`auto-update.yml`](.github/workflows/auto-update.yml)
   downloads `SHA256SUMS`, regenerates `Formula/beeping-cli.rb` with
   the real per-target hashes + new version, and commits to
   `develop`.

The regen script lives at [`scripts/regen-formula.py`](scripts/regen-formula.py)
and is deterministic — feeding the same tag twice produces the same
formula. Manual `workflow_dispatch` with a tag input is available
as a fallback if the dispatch fails.

**Direct edits to `Formula/beeping-cli.rb`** in this repo will be
overwritten on the next release. File any formula-structure changes
upstream in the source-of-truth repo's `external/tap/Formula/beeping-cli.rb`.

## Status

Bootstrapped 2026-05-06 by BEE-151. Auto-update wired 2026-05-11 by
BEE-1782. Until the first `v0.0.x` tag of `beeping-cli` lands the
formula still carries placeholder SHA256 hashes — the first published
release auto-fills them.

## License

[Apache-2.0](LICENSE), matching the binaries it distributes.
