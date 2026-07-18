class MsymCli < Formula
  desc "A CLI tool for downloading Material Symbols Compose code from Google Fonts."
  homepage "https://github.com/shenghaiyang/msym"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/shenghaiyang/msym/releases/download/v0.1.0/msym-cli-aarch64-apple-darwin.tar.xz"
      sha256 "ff6416f20b4aa874b39348adfd1f5d719aeaf1165e11a4ff123e95263f47993b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/shenghaiyang/msym/releases/download/v0.1.0/msym-cli-x86_64-apple-darwin.tar.xz"
      sha256 "c20c8087a7632e30540cc7ebd71b941835011dca71f993bff1d48ed172f82133"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/shenghaiyang/msym/releases/download/v0.1.0/msym-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f391a990c2336698af71c691baf749805c89fceece24ed6d4a48dcd953a0a86b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/shenghaiyang/msym/releases/download/v0.1.0/msym-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d7561fe86797c6aea6a6de3f030def5c1df4b5daff8270bed65dfdf57e1756bd"
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
