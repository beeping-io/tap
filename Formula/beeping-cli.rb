# typed: false
# frozen_string_literal: true

# Homebrew formula for `beeping-cli`. SHA256 hashes are auto-maintained
# by `.github/workflows/auto-update.yml` (BEE-1782): every published
# release of beeping-io/beeping-cli fires a `repository_dispatch` to
# this repo which downloads SHA256SUMS for the new tag, regenerates
# the version + 4 per-target sha256 fields via
# `scripts/regen-formula.py`, and commits to develop. The canonical
# *structure* of this file lives upstream at
# `external/tap/Formula/beeping-cli.rb` in beeping-io/beeping-cli;
# structural edits should land there first, then transplant here.
class BeepingCli < Formula
  desc "Official Rust CLI for the Beeping Platform — data over sound"
  homepage "https://github.com/beeping-io/beeping-cli"
  version "0.0.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/beeping-io/beeping-cli/releases/download/v#{version}/beeping-cli-aarch64-apple-darwin.tar.xz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
    on_intel do
      url "https://github.com/beeping-io/beeping-cli/releases/download/v#{version}/beeping-cli-x86_64-apple-darwin.tar.xz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/beeping-io/beeping-cli/releases/download/v#{version}/beeping-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
    on_intel do
      url "https://github.com/beeping-io/beeping-cli/releases/download/v#{version}/beeping-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
  end

  def install
    bin.install "beeping"
    man1.install "man/beeping.1" if File.exist?("man/beeping.1")
    bash_completion.install "completions/beeping.bash" => "beeping" if File.exist?("completions/beeping.bash")
    zsh_completion.install "completions/_beeping" if File.exist?("completions/_beeping")
    fish_completion.install "completions/beeping.fish" if File.exist?("completions/beeping.fish")
  end

  test do
    assert_match "beeping", shell_output("#{bin}/beeping --version")
  end
end
