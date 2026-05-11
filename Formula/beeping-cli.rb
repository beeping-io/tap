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
  version "0.0.0-test4"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/beeping-io/beeping-cli/releases/download/v#{version}/beeping-cli-aarch64-apple-darwin.tar.xz"
      sha256 "1aa6518992a0749472ecc8a95d6c3678515c52bff8e76f1b3ded41ae40a7c7a1"
    end
    on_intel do
      url "https://github.com/beeping-io/beeping-cli/releases/download/v#{version}/beeping-cli-x86_64-apple-darwin.tar.xz"
      sha256 "347f298db79ef65526b3cd88454a8e9b9cc725bc6f0108a34d699edb9eb56571"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/beeping-io/beeping-cli/releases/download/v#{version}/beeping-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "178585bf889463bde5369fbce38875620365447743edd5de4e74a64b15f0388d"
    end
    on_intel do
      url "https://github.com/beeping-io/beeping-cli/releases/download/v#{version}/beeping-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5e0f74be22d9a8ca648cc180685f65997ef614b4d2f2ecd52fade8c3ef8813db"
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
