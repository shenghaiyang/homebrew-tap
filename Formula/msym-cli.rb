class MsymCli < Formula
  desc "A CLI tool for downloading Material Symbols Compose code from Google Fonts."
  homepage "https://github.com/shenghaiyang/msym"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/shenghaiyang/msym/releases/download/v0.3.1/msym-cli-aarch64-apple-darwin.tar.xz"
      sha256 "12ba40803ba8c57df4793c87d21ab1722794d827080dfaf1bf4b887f885651aa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/shenghaiyang/msym/releases/download/v0.3.1/msym-cli-x86_64-apple-darwin.tar.xz"
      sha256 "431371eedc7044a7d97c18de6a12b830403e675b5399d55108cfab1c128f128d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/shenghaiyang/msym/releases/download/v0.3.1/msym-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bc37adb71ca2c601fa3551ff3cc7e95954da31e97d6df5f06fdace6c29a08075"
    end
    if Hardware::CPU.intel?
      url "https://github.com/shenghaiyang/msym/releases/download/v0.3.1/msym-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "74b026690879c131f5236cb05b317f43df5f0126ff6e83cba87bfab396e26311"
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
