class MsymCli < Formula
  desc "A CLI tool for downloading Material Symbols Compose code from Google Fonts."
  homepage "https://github.com/shenghaiyang/msym"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/shenghaiyang/msym/releases/download/v0.3.0/msym-cli-aarch64-apple-darwin.tar.xz"
      sha256 "d19b3199628ff54afbad122792f6e43b05e830ca2cbdcf0ec4240c2729566580"
    end
    if Hardware::CPU.intel?
      url "https://github.com/shenghaiyang/msym/releases/download/v0.3.0/msym-cli-x86_64-apple-darwin.tar.xz"
      sha256 "48a92c730ddb2bbb5b7ea581407e72c64d6130aaeaea64a613da160a5ddb0582"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/shenghaiyang/msym/releases/download/v0.3.0/msym-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d215d145e89842ec3b1acd13574cd3788891919d54839cc2333dac2512220601"
    end
    if Hardware::CPU.intel?
      url "https://github.com/shenghaiyang/msym/releases/download/v0.3.0/msym-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c32320314022abc76b221a91ed3f72ec0e35850bc622908c260cd3377254c707"
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
