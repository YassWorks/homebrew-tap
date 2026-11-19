class Kubelint < Formula
  desc "A fast, friendly linter for Kubernetes manifests."
  homepage "https://github.com/YassWorks/kubelint"
  version "0.22.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/YassWorks/kubelint/releases/download/v0.22.0/kubelint-aarch64-apple-darwin.tar.gz"
      sha256 "b4a6ef9029b6ac484b7e204a5315c0f8397fb344b366220987e7eacbb9af48ce"
    end
    if Hardware::CPU.intel?
      url "https://github.com/YassWorks/kubelint/releases/download/v0.22.0/kubelint-x86_64-apple-darwin.tar.gz"
      sha256 "81d757cef03943f69344197cacb89a0b9cd56c5ba2f7e96ba95f9dd41c12dcbd"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/YassWorks/kubelint/releases/download/v0.22.0/kubelint-aarch64-unknown-linux-musl.tar.gz"
      sha256 "ec4599c10d2b31d27425237b91da30768d5ca6ea20794f404b885b0ea629fb52"
    end
    if Hardware::CPU.intel?
      url "https://github.com/YassWorks/kubelint/releases/download/v0.22.0/kubelint-x86_64-unknown-linux-musl.tar.gz"
      sha256 "774f624a714b17716515fef6bf2cd1221fbe0129f7a4e85d850030e79d44e5fe"
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
