class MsymCli < Formula
  desc "A CLI tool for downloading Material Symbols Compose code from Google Fonts."
  homepage "https://github.com/shenghaiyang/msym"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/shenghaiyang/msym/releases/download/v0.2.0/msym-cli-aarch64-apple-darwin.tar.xz"
      sha256 "407fdbd0c21c2fcc6024df8ca0868528e3c006fdbb7adda711529013a75596ba"
    end
    if Hardware::CPU.intel?
      url "https://github.com/shenghaiyang/msym/releases/download/v0.2.0/msym-cli-x86_64-apple-darwin.tar.xz"
      sha256 "242f5a4ed8ec6ad0e138d48fb5493b5821e84c757213352b91e47b4f8b9dabb0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/shenghaiyang/msym/releases/download/v0.2.0/msym-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6db4584f0924bfa50717dbed1b9ba8130d3b0174b4d115d42cfd60a2347b056c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/shenghaiyang/msym/releases/download/v0.2.0/msym-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c7683782a237f74182328dcbce455009966db96038cc03fdbefe1a796700591f"
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
    bin.install "msym" if OS.mac? && Hardware::CPU.arm?
    bin.install "msym" if OS.mac? && Hardware::CPU.intel?
    bin.install "msym" if OS.linux? && Hardware::CPU.arm?
    bin.install "msym" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
