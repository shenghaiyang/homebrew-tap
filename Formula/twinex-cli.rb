class TwinexCli < Formula
  desc "A localization code generator compatible with the Twine file format"
  homepage "https://github.com/shenghaiyang/twinex"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/shenghaiyang/twinex/releases/download/v0.3.0/twinex-cli-aarch64-apple-darwin.tar.xz"
      sha256 "0f583fcb24bb242ba75aeeeb4bc01bf32e3d24613f5c7c404521f408c800e311"
    end
    if Hardware::CPU.intel?
      url "https://github.com/shenghaiyang/twinex/releases/download/v0.3.0/twinex-cli-x86_64-apple-darwin.tar.xz"
      sha256 "0243b6e96dd3948136d0249aee4ba481e57c9b1363a4817f771a3f997b8099ee"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/shenghaiyang/twinex/releases/download/v0.3.0/twinex-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f6fc4edc2632b5d1bb0d76c20788bc8565d89b4f5ba95ca82bfa4fcaee8519fd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/shenghaiyang/twinex/releases/download/v0.3.0/twinex-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5adf0df46a7c03300a48c38dc4c47be407982f896a1aebbf4122824c36329c3c"
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
