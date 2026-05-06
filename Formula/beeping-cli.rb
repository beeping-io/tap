# typed: false
# frozen_string_literal: true

# Homebrew formula for `beeping-cli`. Bootstrap version: SHA256 hashes are
# placeholders that BEE-1782 will rewrite automatically on every release.
# Until BEE-1782 lands, post-release the maintainer regenerates this
# file with `shasum -a 256` against each tarball + commits the result
# (manual cycle; documented in `external/README.md`).
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
