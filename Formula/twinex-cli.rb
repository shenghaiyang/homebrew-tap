class TwinexCli < Formula
  desc "Rust localization code generator compatible with the Twine file format."
  homepage "https://github.com/shenghaiyang/twinex"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/shenghaiyang/twinex/releases/download/v0.2.0/twinex-cli-aarch64-apple-darwin.tar.xz"
      sha256 "03b8c7d3d3db6fe4f6833f5f7f85653b54e726d563040f8326c14881412fde5a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/shenghaiyang/twinex/releases/download/v0.2.0/twinex-cli-x86_64-apple-darwin.tar.xz"
      sha256 "d826881a4b6760047a9b922af3fbabb259324e287311485bb543317bd30a3bf5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/shenghaiyang/twinex/releases/download/v0.2.0/twinex-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "06570d71df1747df1c86495cc2bf7db1232c01de5445549fb298063187a67ab6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/shenghaiyang/twinex/releases/download/v0.2.0/twinex-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "54ac5b9bf8f821746b9ab05d0333b55f7f2f30d11a4956708705ae2511b81ec2"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-pc-windows-gnu":    {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
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
    bin.install "twinex" if OS.mac? && Hardware::CPU.arm?
    bin.install "twinex" if OS.mac? && Hardware::CPU.intel?
    bin.install "twinex" if OS.linux? && Hardware::CPU.arm?
    bin.install "twinex" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
