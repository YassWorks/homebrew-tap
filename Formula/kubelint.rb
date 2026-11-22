class Kubelint < Formula
  desc "A fast, friendly linter for Kubernetes manifests."
  homepage "https://github.com/YassWorks/kubelint"
  version "0.22.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/YassWorks/kubelint/releases/download/v0.22.2/kubelint-aarch64-apple-darwin.tar.gz"
      sha256 "ca29b8d472c9be964454e1719b24823b82b8b4bcaf8667599419242c8ce70064"
    end
    if Hardware::CPU.intel?
      url "https://github.com/YassWorks/kubelint/releases/download/v0.22.2/kubelint-x86_64-apple-darwin.tar.gz"
      sha256 "a33be017fdf09c7ae83400b78fd9f131de082b8026bd60515c0df68cac365476"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/YassWorks/kubelint/releases/download/v0.22.2/kubelint-aarch64-unknown-linux-musl.tar.gz"
      sha256 "214d15d3ca79ce5cb70191549e329f34d8d6c081d7964f8a872976922e143e81"
    end
    if Hardware::CPU.intel?
      url "https://github.com/YassWorks/kubelint/releases/download/v0.22.2/kubelint-x86_64-unknown-linux-musl.tar.gz"
      sha256 "ecee1d7c99b35fb62fc155a1d921d3bd8eb130add9008fb8a004b9f3e9dd9c83"
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
