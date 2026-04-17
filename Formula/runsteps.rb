class Runsteps < Formula
  desc "Interactive config-driven task runner"
  homepage "https://runsteps.silafood.app"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/silafood/runsteps/releases/download/v0.2.0/runsteps-aarch64-apple-darwin.tar.xz"
      sha256 "88651776740b470a167d77aff2ca204ff6ad731f676b7ffbc53f3c66339f79ad"
    end
    if Hardware::CPU.intel?
      url "https://github.com/silafood/runsteps/releases/download/v0.2.0/runsteps-x86_64-apple-darwin.tar.xz"
      sha256 "63dd007ac99502453ee001f8c2a55ae3a7b5109bce0a4e4dee077951514e7c04"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/silafood/runsteps/releases/download/v0.2.0/runsteps-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9cd3db264d131c4e26325b0e1594b796b0d11e0ed8860445273e77251680db30"
    end
    if Hardware::CPU.intel?
      url "https://github.com/silafood/runsteps/releases/download/v0.2.0/runsteps-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8f1cd9316bfe8091dc21ba24dcad91647fef0726723c42eb7ec9007ae6fdab90"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
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
    bin.install "runsteps" if OS.mac? && Hardware::CPU.arm?
    bin.install "runsteps" if OS.mac? && Hardware::CPU.intel?
    bin.install "runsteps" if OS.linux? && Hardware::CPU.arm?
    bin.install "runsteps" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
