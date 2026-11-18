class Kubelint < Formula
  desc "A fast, friendly linter for Kubernetes manifests."
  homepage "https://github.com/YassWorks/kubelint"
  version "0.21.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/YassWorks/kubelint/releases/download/v0.21.0/kubelint-aarch64-apple-darwin.tar.gz"
      sha256 "f204e65d7f6e753fc5899b8a0c0f8eb4f1eb5f17ef07546d01d40af6e9d6cb6c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/YassWorks/kubelint/releases/download/v0.21.0/kubelint-x86_64-apple-darwin.tar.gz"
      sha256 "8d4d5bd7cf06194da9c49f5f3087adacae8229e2d1aec13b592490aab4926ff0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/YassWorks/kubelint/releases/download/v0.21.0/kubelint-aarch64-unknown-linux-musl.tar.gz"
      sha256 "116d203cd9b18c71e3e292a6f2746abe4c8fcf4d789eae32ef1316c84e750b26"
    end
    if Hardware::CPU.intel?
      url "https://github.com/YassWorks/kubelint/releases/download/v0.21.0/kubelint-x86_64-unknown-linux-musl.tar.gz"
      sha256 "63e85509654f880582bcd4861144d76a5f8d870e4c27c55cd3a949637c351c66"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-pc-windows-gnu":              {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "kubelint"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "kubelint"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "kubelint"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "kubelint"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
