#!/usr/bin/env python3
"""Regenerate Homebrew formula SHA256 hashes + version from a SHA256SUMS file.

BEE-1782 — invoked by `.github/workflows/auto-update.yml` after a new
`beeping-cli` release publishes. Reads the release's `SHA256SUMS`
asset, parses the 4 expected target lines, rewrites the formula's
`version` field + the 4 `sha256` fields in-place.

Usage:
    regen-formula.py --formula Formula/beeping-cli.rb \\
                     --sha256sums /tmp/SHA256SUMS \\
                     --version 0.1.2

The script is intentionally strict: if any target is missing from
SHA256SUMS, it exits non-zero rather than producing a half-updated
formula. The release pipeline already guarantees that all 4
Homebrew-supported targets (macOS arm64 + intel, Linux arm64 + intel)
appear in SHA256SUMS for any non-partial release.
"""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

EXPECTED_TARGETS = [
    "aarch64-apple-darwin",
    "x86_64-apple-darwin",
    "aarch64-unknown-linux-gnu",
    "x86_64-unknown-linux-gnu",
]


def parse_sha256sums(text: str) -> dict[str, str]:
    """Parse `SHA256SUMS` lines into {target → sha}.

    Accepts both BSD format (`SHA256 (file) = hash`) and GNU/coreutils
    format (`hash  file`). Skips Windows .zip and other non-tarball
    entries since Homebrew doesn't ship Windows formulae.
    """
    out: dict[str, str] = {}
    for line in text.splitlines():
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        # GNU format: hash<space><space>filename (or single space accepted)
        m = re.match(r"^([0-9a-f]{64})\s+\*?(\S+)$", line)
        if m:
            sha, fname = m.group(1), m.group(2)
        else:
            # BSD format: SHA256 (filename) = hash
            m = re.match(r"^SHA256 \(([^)]+)\) = ([0-9a-f]{64})$", line)
            if m:
                fname, sha = m.group(1), m.group(2)
            else:
                continue
        for target in EXPECTED_TARGETS:
            if fname == f"beeping-cli-{target}.tar.xz":
                out[target] = sha
                break
    return out


def rewrite_formula(formula_text: str, version: str, shas: dict[str, str]) -> str:
    """Return the formula with the version + per-target SHAs updated.

    The formula structure (BEE-151 bootstrap) is::

        version "X.Y.Z"
        ...
        on_macos do
          on_arm do
            url ".../v#{version}/beeping-cli-aarch64-apple-darwin.tar.xz"
            sha256 "..."
          end
          ...

    We rewrite by matching `url ".../<target>.tar.xz"` then replacing
    the next `sha256 "..."` line within the same block.
    """
    # Update version line
    new = re.sub(
        r'^(\s*version\s+)"[^"]*"',
        rf'\g<1>"{version}"',
        formula_text,
        count=1,
        flags=re.MULTILINE,
    )

    for target, sha in shas.items():
        pattern = (
            r'(url\s+"[^"]*'
            + re.escape(target)
            + r'\.tar\.xz"\s*\n\s*sha256\s+)"[^"]*"'
        )
        new, n = re.subn(pattern, rf'\g<1>"{sha}"', new, count=1)
        if n != 1:
            raise SystemExit(
                f"failed to locate sha256 line for target {target}; "
                f"formula structure may have changed",
            )
    return new


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--formula", type=Path, required=True)
    ap.add_argument("--sha256sums", type=Path, required=True)
    ap.add_argument(
        "--version",
        required=True,
        help="Tag without leading 'v' (e.g. 0.1.2)",
    )
    args = ap.parse_args()

    shas = parse_sha256sums(args.sha256sums.read_text())
    missing = [t for t in EXPECTED_TARGETS if t not in shas]
    if missing:
        print(
            "::error::SHA256SUMS missing targets: " + ", ".join(missing),
            file=sys.stderr,
        )
        return 1

    old = args.formula.read_text()
    new = rewrite_formula(old, args.version, shas)
    if new == old:
        print("::warning::formula content unchanged after regen")
    args.formula.write_text(new)

    print(f"::notice::Regenerated {args.formula} -> version {args.version}")
    for target, sha in shas.items():
        print(f"  {target}: {sha}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
