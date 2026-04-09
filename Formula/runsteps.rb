class Runsteps < Formula
  desc "Interactive config-driven task runner"
  homepage "https://silafood.github.io/runsteps"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/silafood/runsteps/releases/download/v0.1.0/runsteps-aarch64-apple-darwin.tar.xz"
      sha256 "b276dd734418fdd7c309d959bac9a69fff226e4927808d0e9fb66dfbffb6d079"
    end
    if Hardware::CPU.intel?
      url "https://github.com/silafood/runsteps/releases/download/v0.1.0/runsteps-x86_64-apple-darwin.tar.xz"
      sha256 "fa63a6869c7c4cbdf9417853a91ec9709116b8f741732d3eae21d8048f528f55"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/silafood/runsteps/releases/download/v0.1.0/runsteps-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "126aa9f22d42b61fdc83cd63ecf533763f2d148f5741835f59e09f520f5c3178"
    end
    if Hardware::CPU.intel?
      url "https://github.com/silafood/runsteps/releases/download/v0.1.0/runsteps-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "07ea19e13b1e7906392dbec5bafedd43d515a22317d028ebce127dc9b69ead4b"
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
