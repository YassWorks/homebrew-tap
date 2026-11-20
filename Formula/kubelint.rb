class Kubelint < Formula
  desc "A fast, friendly linter for Kubernetes manifests."
  homepage "https://github.com/YassWorks/kubelint"
  version "0.22.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/YassWorks/kubelint/releases/download/v0.22.1/kubelint-aarch64-apple-darwin.tar.gz"
      sha256 "e4b5fbb33d6c9f5a02005955f4cec10d372ff72e3430324e9f5dd79a50bdb6c7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/YassWorks/kubelint/releases/download/v0.22.1/kubelint-x86_64-apple-darwin.tar.gz"
      sha256 "9a32dac1d579a87bab1a372d6c3c09f3ba8ac369213827523422969bea44b89b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/YassWorks/kubelint/releases/download/v0.22.1/kubelint-aarch64-unknown-linux-musl.tar.gz"
      sha256 "c18592b2ae8ef18f92fbeb8d5b8649a0b550980dd3819a6153bfc4d32a479f99"
    end
    if Hardware::CPU.intel?
      url "https://github.com/YassWorks/kubelint/releases/download/v0.22.1/kubelint-x86_64-unknown-linux-musl.tar.gz"
      sha256 "fd7450de708ab3f58e7a7c4b9f537d20d25ed0e6210b8cb512e87a97a80eef24"
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
